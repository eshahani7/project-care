//
//  HealthStore.swift
//  projectCARE
//
//  Created by Ekta Shahani on 2/1/18.
//  Copyright © 2018 Ekta Shahani. All rights reserved.
//

import Foundation
import HealthKit

class HealthStore {
    
    let store:HKHealthStore?
    
    enum HealthStoreErrors : Error {
        case noHealthDataFound
        case noAgeFound
        case noSexEntered
    }
    
    private enum HealthkitSetupError: Error {
        case notAvailableOnDevice
        case dataTypeNotAvailable
    }
    
    class func authorizeHealthKit(completion: @escaping (Bool, Error?) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, HealthkitSetupError.notAvailableOnDevice)
            return
        }
        
        guard   let dateOfBirth = HKObjectType.characteristicType(forIdentifier: .dateOfBirth),
                let biologicalSex = HKObjectType.characteristicType(forIdentifier: .biologicalSex),
                let bodyMassIndex = HKObjectType.quantityType(forIdentifier: .bodyMassIndex),
                let height = HKObjectType.quantityType(forIdentifier: .height),
                let bodyMass = HKObjectType.quantityType(forIdentifier: .bodyMass),
                let activeEnergy = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned),
                let exerciseTime = HKObjectType.quantityType(forIdentifier: .appleExerciseTime),
                let stepCount = HKObjectType.quantityType(forIdentifier: .stepCount),
                let heartRate = HKObjectType.quantityType(forIdentifier: .heartRate),
                let respRate = HKObjectType.quantityType(forIdentifier: .respiratoryRate) else {
                
                    completion(false, HealthkitSetupError.dataTypeNotAvailable)
                    return
        }
        
        let writeTypes: Set<HKSampleType> = [stepCount,
                                        HKObjectType.workoutType()]
        
        let readTypes: Set<HKObjectType> = [activeEnergy,
                                            dateOfBirth,
                                            biologicalSex,
                                            bodyMassIndex,
                                            height,
                                            bodyMass,
                                            exerciseTime,
                                            stepCount,
                                            heartRate,
                                            respRate,
                                            HKObjectType.workoutType()]
        
        HKHealthStore().requestAuthorization(toShare: writeTypes, read: readTypes, completion: { (success, error) in
            completion(success, error)
        })
    }
    
    init() {
        if(HKHealthStore.isHealthDataAvailable()) {
            store = HKHealthStore()
            print("data found")
        } else {
            print("no data")
            store = nil
        }
    }
    
    
    //Params: sample type, start date, end date, callback
    //Returns: array of samples if not nil, error if nil
    func getSample(sampleType: HKSampleType, startDate: Date, endDate: Date,
                   completion: @escaping([HKQuantitySample]?, Error?) -> Void) {
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictEndDate)
        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: nil) { (query, results, error) in
            
            DispatchQueue.main.async {
                guard let samples = results as? [HKQuantitySample] else {
                    completion(nil, error)
                    return
                }
                
                completion(samples, nil)
                
            }
        }
        
        store?.execute(query)
    }
    
    func getAge() -> Int {
        do {
            let dob = try store?.dateOfBirthComponents()
            let today = Date()
            let calendar = Calendar.current
            let todayDateComponents = calendar.dateComponents([.year],
                                                              from: today)
            let thisYear = todayDateComponents.year!
            let age = thisYear - (dob?.year!)!
            return age
        } catch {
            print("can't get dob")
        }
        
        return 0
    }
    
    func getBiologicalSex() -> HKBiologicalSexObject? {
        do {
            return try store?.biologicalSex()
        } catch {
            print("Can't get biological sex")
            return nil
        }
    }
    
    func retrieveMostRecentStepCountSample(completionHandler: @escaping (HKQuantitySample) -> Void) {
        let sampleType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
        let predicate = HKQuery.predicateForSamples(withStart: NSDate.distantPast, end: NSDate() as Date, options:[])
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        let query = HKSampleQuery(sampleType: sampleType!, predicate: predicate, limit: 1, sortDescriptors: [sortDescriptor])
        { (query, results, error) in
            if error != nil {
                print("An error has occured with the following description: \(String(describing: error?.localizedDescription))")
            } else {
                let mostRecentSample = results![0] as! HKQuantitySample
                print("Retrieved most recent step count.")
                completionHandler(mostRecentSample)
            }
        }
        store?.execute(query)
    }
    
    var observeQuery: HKObserverQuery!
    
    public var steps = 0.0
    
    func startObservingForStepCountSamples() {
        print("startObservingForStepCountSamples")
        let sampleType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
        
        if observeQuery != nil {
            store?.stop(observeQuery)
        }
        
        observeQuery = HKObserverQuery(sampleType: sampleType!, predicate: nil) {
            (query, completionHandler, error) in
            
            if error != nil {
                print("An error has occured with the following description: \(String(describing: error?.localizedDescription))")
            } else {
                self.retrieveMostRecentStepCountSample {
                    (sample) in
                    print("New steps: \(sample.quantity.doubleValue(for: HKUnit.count()))")
                    self.steps += sample.quantity.doubleValue(for: HKUnit.count())
                }
            }
        }
        store?.execute(observeQuery)
    }
}
