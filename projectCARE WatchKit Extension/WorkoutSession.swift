//
//  WorkoutSession.swift
//  projectCARE WatchKit Extension
//
//  Created by Aditya Nadkarni on 3/1/18.
//  Copyright © 2018 Ekta Shahani. All rights reserved.
//

import Foundation
import WatchKit
import HealthKit

class WorkoutSession: NSObject, HKWorkoutSessionDelegate {
    
    //Properties
    let healthStore = HKHealthStore()
    
    var isStarted = false
    var workoutActive = false
    
    var currenQuery : HKQuery?
    
    var session : HKWorkoutSession?
    let heartRateUnit = HKUnit(from: "count/min")
    
    var startDate:Date = Date()
    var endDate:Date = Date()

    //Methods
    
    //Called when the workout sessoin changes state
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        switch toState {
        case .running:
            workoutDidStart(date)
        case .ended:
            workoutDidEnd(date)
        default:
            print("Unexpected state \(toState)")
        }
    }
    
    //Incase there's an error in the workout session
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        // Do nothing for now
        print("Workout error")
    }
    
    func workoutDidStart(_ date : Date) {
        if let query = createHeartRateStreamingQuery(date) {
            self.currenQuery = query
            //healthStore.execute(query)
        } else {
            //HeartRateLabel.setText("cannot start")
        }
    }
    
    func workoutDidEnd(_ date : Date) {
        healthStore.stop(self.currenQuery!)
        //HeartRateLabel.setText("Heart Rate: ---")
        session = nil
    }
    
    //Called from the view controller to start the workout
    func startWorkout(completion: @escaping(Bool?) -> Void) {
        // If we have already started the workout, then do nothing.
        if (session != nil) {
            completion(false)
            print("Workout already started")
            return
        }
        
        startDate = Date()
        
        // Configure the workout session.
        let workoutConfiguration = HKWorkoutConfiguration()
        workoutConfiguration.activityType = .running
        workoutConfiguration.locationType = .indoor
        
        do {
            session = try HKWorkoutSession(configuration: workoutConfiguration)
            session?.delegate = self
        } catch {
            fatalError("Unable to create the workout session!")
            completion(false)
        }
        
        healthStore.start(self.session!)
        completion(true)
    }
    
    var heartRateIntervalSamples = [HKQuantitySample]();
    
    //Called from the View Controller to end the workout
    func endWorkout(intensity: Int, time: Double, calorieBurnGoal: Double?, completion: @escaping(Bool?, Error?) -> Void) {
        endDate = Date()
        guard let activeEnergyType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned) else {
            fatalError("*** Unable to create the active energy burned type ***")
        }
        
        guard let distanceTraveledType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning) else {
            fatalError("*** Unable to create the active energy burned type ***")
        }
        
        let device = HKDevice.local()
        
        let datePredicate = HKQuery.predicateForSamples(withStart: self.session?.startDate, end: self.session?.endDate)
        let devicePredicate = HKQuery.predicateForObjects(from: [device])
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates:[datePredicate, devicePredicate])
        
        let sortByDate = NSSortDescriptor(key:HKSampleSortIdentifierStartDate , ascending: true)
        
        let healthStore = self.healthStore
        
        let query = HKSampleQuery(sampleType: activeEnergyType, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: [sortByDate]) { (query, returnedSamples, error) -> Void in
            
            guard var samples = returnedSamples as? [HKQuantitySample] else {
                // Add proper error handling here...
                print("*** an error occurred: \(String(describing: error?.localizedDescription)) ***")
                completion(false, error)
                return
            }
            
            // create the workout here
            let energyUnit = HKUnit.kilocalorie()
            let distanceUnit = HKUnit.foot()
            var totalActiveEnergy : Double = 0.0
            
            for sample in samples {
                totalActiveEnergy += sample.quantity.doubleValue(for: energyUnit)
            }
            
            //            let startDate = self.session?.startDate ?? NSDate() as Date
            //            let endDate = self.session?.endDate ?? NSDate() as Date
            
            var duration: TimeInterval {
                return (self.endDate.timeIntervalSince((self.startDate)))
            }
            
            print ("Duration: \(duration)")
            
            let totalActiveEnergyQuantity = HKQuantity(unit: energyUnit, doubleValue: totalActiveEnergy)
            
            let workout = HKWorkout(activityType: HKWorkoutActivityType.running,
                                    start: self.startDate,
                                    end: self.endDate,
                                    duration: duration,
                                    totalEnergyBurned: totalActiveEnergyQuantity,
                                    totalDistance: nil,
                                    device: HKDevice.local(),
                                    metadata: [HKMetadataKeyIndoorWorkout : true, "IntensityLevel" : intensity, "UserEnteredDuration" : time, "CalorieBurnGoal" : calorieBurnGoal ])
            
            guard healthStore.authorizationStatus(for: HKObjectType.workoutType()) == .sharingAuthorized else {
                print("*** the app does not have permission to save workout samples ***")
                return
            }
            
            healthStore.save(workout, withCompletion: { (success, error) -> Void in
                guard success else {
                    // Add proper error handling here...
                    print("*** an error occurred: \(String(describing: error?.localizedDescription)) ***")
                    //self.displayNotAllowed()
                    return
                }
                
                for sample in self.heartRateIntervalSamples {
                    samples.append(sample)
                }
                
                healthStore.add(samples, to: workout, completion: { (success, error) -> Void in
                    guard success else {
                        // Add proper error handling here...
                        print("*** an error occurred: \(String(describing: error?.localizedDescription)) ***")
                        return
                    }
                    
                    // Provide clear feedback that the workout saved successfully here…
                    print("Workout saved!")
                    completion(true, nil)
                    //self.HeartRateLabel.setText("Workout Saved!")
                })
            })
        }
        healthStore.execute(query)
    }
    
    //Creates an anchor query for the view controller to execute. Does not add the updateHandler --> Needs to be done in the View Controller
    func createHeartRateStreamingQuery(_ workoutStartDate: Date) -> HKAnchoredObjectQuery? {
        
        
        guard let quantityType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate) else { return nil }
        let datePredicate = HKQuery.predicateForSamples(withStart: workoutStartDate, end: nil, options: .strictEndDate )
        //let devicePredicate = HKQuery.predicateForObjects(from: [HKDevice.local()])
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates:[datePredicate])
        
        
        let heartRateQuery = HKAnchoredObjectQuery(type: quantityType, predicate: predicate, anchor: nil, limit: Int(HKObjectQueryNoLimit)) { (query, sampleObjects, deletedObjects, newAnchor, error) -> Void in
            //guard let newAnchor = newAnchor else {return}
            //self.anchor = newAnchor
            //self.updateHeartRate(sampleObjects)
        }
        
        return heartRateQuery
    }
    
}

