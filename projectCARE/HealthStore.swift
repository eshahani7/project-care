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
}

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
    func getSamples(sampleType: HKSampleType, startDate: Date, endDate: Date,
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
}
