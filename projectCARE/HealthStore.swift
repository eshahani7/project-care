//
//  HealthStore.swift
//  projectCARE
//
//  Created by Ekta Shahani on 2/1/18.
//  Copyright © 2018 Ekta Shahani. All rights reserved.
//

import Foundation
import HealthKit

//use for first parameter of getSamples()
struct HealthValues {
    static let dateOfBirth = HKObjectType.characteristicType(forIdentifier: .dateOfBirth)
    static let biologicalSex = HKObjectType.characteristicType(forIdentifier: .biologicalSex)
    static let bodyMassIndex = HKObjectType.quantityType(forIdentifier: .bodyMassIndex)
    static let height = HKObjectType.quantityType(forIdentifier: .height)
    static let bodyMass = HKObjectType.quantityType(forIdentifier: .bodyMass)
    static let activeEnergy = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)
    static let exerciseTime = HKObjectType.quantityType(forIdentifier: .appleExerciseTime)
    static let stepCount = HKObjectType.quantityType(forIdentifier: .stepCount)
    static let heartRate = HKObjectType.quantityType(forIdentifier: .heartRate)
    static let respRate = HKObjectType.quantityType(forIdentifier: .respiratoryRate)
    static let workouts = HKObjectType.workoutType()
}

class HealthStore {
    
    static var shared:HealthStore? = nil
    
    let store:HKHealthStore?
    
    private enum HealthStoreErrors : Error {
        case noHealthDataFound
        case noAgeFound
        case noSexEntered
    }
    
    private enum HealthkitSetupError: Error {
        case notAvailableOnDevice
        case dataTypeNotAvailable
    }
    
    private static func authorizeHealthKit(completion: @escaping (Bool, Error?) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, HealthkitSetupError.notAvailableOnDevice)
            return
        }
        
        guard   let dateOfBirth = HealthValues.dateOfBirth,
            let biologicalSex = HealthValues.biologicalSex,
            let bodyMassIndex = HealthValues.bodyMassIndex,
            let height = HealthValues.height,
            let bodyMass = HealthValues.bodyMass,
            let activeEnergy = HealthValues.activeEnergy,
            let exerciseTime = HealthValues.exerciseTime,
            let stepCount = HealthValues.stepCount,
            let heartRate = HealthValues.heartRate,
            let respRate = HealthValues.respRate else {
                
                completion(false, HealthkitSetupError.dataTypeNotAvailable)
                return
        }
        
        let writeTypes: Set<HKSampleType> = [stepCount, activeEnergy, heartRate,
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
    
    private init() {
        HealthStore.authorizeHealthKit { (authorized, error) in
            
            guard authorized else {
                
                let baseMessage = "HealthKit Authorization Failed"
                
                if let error = error {
                    print("\(baseMessage). Reason: \(error.localizedDescription)")
                } else {
                    print(baseMessage)
                }
                
                return
            }
            
            print("HealthKit Successfully Authorized.")
        }
        
        if(HKHealthStore.isHealthDataAvailable()) {
            store = HKHealthStore()
            print("data found")
        } else {
            print("no data")
            store = nil
        }
    }
    
    public static func getInstance() -> HealthStore {
        if shared == nil {
            shared = HealthStore()
        }
        return shared!
    }
    
    //Params: sample type, start date, end date, callback
    //Returns: array of samples if not nil, error if nil
    public func getSamples(sampleType: HKSampleType, startDate: Date, endDate: Date,
                           completion: @escaping([HKQuantitySample]?, Error?) -> Void) {
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictEndDate)
        
        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: nil) { (query, results, error) in
            
            DispatchQueue.global().async {
                guard let samples = results as? [HKQuantitySample] else {
                    completion(nil, error)
                    return
                }
                
                completion(samples, nil)
                
            }
        }
        
        store?.execute(query)
    }
    
    //same as above but enter your own predicate and limit
    public func getSamples(sampleType: HKSampleType, predicate: NSPredicate, limit: Int,
                           completion: @escaping([HKQuantitySample]?, Error?) -> Void) {
        
        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: limit, sortDescriptors: nil) { (query, results, error) in
            
            DispatchQueue.global().async {
                guard let samples = results as? [HKQuantitySample] else {
                    completion(nil, error)
                    return
                }
                
                completion(samples, nil)
                
            }
        }
        
        store?.execute(query)
    }
    
    func retrieveStepCount(completion: @escaping (_ stepRetrieved: [Double]) -> Void) {
        let stepsCount = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
        let newDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())
        let predicate = HKQuery.predicateForSamples(withStart: newDate, end: Date(), options: .strictStartDate)
        var interval = DateComponents()
        interval.day = 1
        let query = HKStatisticsCollectionQuery(quantityType: stepsCount!, quantitySamplePredicate: predicate, options: [.cumulativeSum], anchorDate: newDate! as Date, intervalComponents:interval)
        query.initialResultsHandler = { query, results, error in
            if error != nil {
                print("nooo")
                return
            }
            let statsCollection = results
            let endDate = Date()
            let startDate = Calendar.current.date(byAdding: .day, value: -7, to: endDate as Date)
            
            var arr = [Double]()
            // Plot the weekly step counts over the past 3 months
            statsCollection?.enumerateStatistics(from: startDate!, to: endDate as Date) { statistics, stop in
                if let quantity = statistics.sumQuantity() {
                    //                    let date = statistics.startDate
                    let value = quantity.doubleValue(for: HKUnit.count())
                    // Call a custom method to plot each data point.
                    arr.append(value)
                }
            }
            completion(arr)
        }
        store?.execute(query)
    }
    
    public func getWorkouts(completion: @escaping([HKWorkout]?, Error?) -> Void) {
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        let query = HKSampleQuery(sampleType: HealthValues.workouts, predicate:nil , limit: 10, sortDescriptors: [sortDescriptor]) {(query, results, error) in
            DispatchQueue.global().async {
                guard let samples = results as? [HKWorkout] else {
                    completion(nil, error)
                    return
                }
                
                completion(samples, nil)
                
            }
        }
        
        store?.execute(query)
    }
    
    public func getAge() -> Int {
        do {
            let dob = try store?.dateOfBirthComponents()
            let today = Date()
            let calendar = Calendar.current
            let todayDateComponents = calendar.dateComponents([.year],
                                                              from: today)
            let todayMonthComponents = calendar.dateComponents([.month],
                                                               from: today)
            let thisYear = todayDateComponents.year!
            let thisMonth = todayMonthComponents.month!
            
            let age:Int
            
            if (dob?.month)! <= thisMonth {
                age = thisYear - (dob?.year!)!
            } else {
                age = thisYear - (dob?.year!)! - 1
            }
            
            return age
        } catch {
            print("can't get dob")
        }
        
        return 0
    }
    
    public func getBiologicalSex() -> HKBiologicalSexObject? {
        do {
            return try store?.biologicalSex()
        } catch {
            print("Can't get biological sex")
            return nil
        }
    }
    
}
