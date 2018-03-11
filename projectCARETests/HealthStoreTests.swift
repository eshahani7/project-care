//
//  HealthStoreTests.swift
//  projectCARE
//
//  Created by Ekta Shahani on 2/21/18.
//  Copyright © 2018 Ekta Shahani. All rights reserved.
//
import XCTest
import HealthKit

class HealthStoreTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testHealthStoreGetInstance() {
        let store:HealthStore = HealthStore.getInstance()
        XCTAssertNotNil(store)
    }
    
    func testHealthStoreGetAge() {
        let store:HealthStore = HealthStore.getInstance()
        let simulatorAge:Int = 21
        XCTAssertEqual(store.getAge(), simulatorAge)
    }
    
    func testHealthStoreGetSamples() {
        let expectation = self.expectation(description: "got samples")
        let store:HealthStore = HealthStore.getInstance()
        
        //---------------------SEEDING----------------------------------//
        let appleStore:HKHealthStore = HKHealthStore()
        
        let steps1 = HKQuantity(unit: HKUnit.count(), doubleValue: 1000)
        let stepSample1 = HKQuantitySample(type: HealthValues.stepCount!, quantity: steps1, start: Date(), end: Date())
        
        appleStore.save(stepSample1) { (success, error) in
            
            if let error = error {
                print("Error Saving step: \(error.localizedDescription)")
            } else {
                print("Successfully saved step sample")
            }
        }
        //---------------------SEEDING----------------------------------//
        
        store.getSamples(sampleType: HealthValues.stepCount!, startDate: Date.distantPast, endDate: Date()) { (sample, error) in
            guard let samples = sample else {
                if let error = error {
                    print(error)
                    XCTFail()
                }
                return
            }
            
            if samples.count > 0 {
                expectation.fulfill()
            } else {
                XCTFail()
            }
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testHealthStoreRetriveStepCount() {
        let expectation = self.expectation(description: "got step count")
        let store:HealthStore = HealthStore.getInstance()
        
        //---------------------SEEDING----------------------------------//
        let appleStore:HKHealthStore = HKHealthStore()
        
        let steps1 = HKQuantity(unit: HKUnit.count(), doubleValue: 1000)
        let stepSample1 = HKQuantitySample(type: HealthValues.stepCount!, quantity: steps1, start: Date(), end: Date())
        
        appleStore.save(stepSample1) { (success, error) in
            
            if let error = error {
                print("Error Saving step: \(error.localizedDescription)")
            } else {
                print("Successfully saved step sample")
            }
        }
        //---------------------SEEDING----------------------------------//
        
        store.retrieveStepCount() { (steps) in
            if steps.count > 0 {
                expectation.fulfill()
            } else {
                XCTFail()
            }
        }
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testHealthStoreGetExerciseTime() {
        let expectation = self.expectation(description: "got step count")
        let store:HealthStore = HealthStore.getInstance()
        
        //---------------------SEEDING----------------------------------//
        let appleStore:HKHealthStore = HKHealthStore()

        let calorieQuantity = HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: 200)
        let distQuantity = HKQuantity(unit: HKUnit.mile(), doubleValue: 4)
        
        let workout = HKWorkout(activityType: .running,
                                start: Date().addingTimeInterval(2 * 1),
                                end: Date().addingTimeInterval(2 * 1 + 20*60),
                                duration: 20 * 60,
                                totalEnergyBurned: calorieQuantity,
                                totalDistance: distQuantity,
                                device: HKDevice.local(),
                                metadata: nil)
        
        appleStore.save(workout) { (success, error) in
            
            if let error = error {
                print("Error Saving step: \(error.localizedDescription)")
            } else {
                var samples: [HKQuantitySample] = []
                let heartRateUnit = HKUnit(from: "count/min")
                let heartRateQuantity = HKQuantity(unit: heartRateUnit, doubleValue: 95)
                let heartRateForIntervalSample =
                    HKQuantitySample(type: HealthValues.heartRate!, quantity: heartRateQuantity,
                                     start: Date(), end: Date())
                let heartRateForIntervalSample2 =
                    HKQuantitySample(type: HealthValues.heartRate!, quantity: heartRateQuantity,
                                     start: Date().addingTimeInterval(20), end: Date().addingTimeInterval(40))
                samples.append(heartRateForIntervalSample)
                samples.append(heartRateForIntervalSample2)
                
                appleStore.add(samples, to: workout) {
                    (success, error) in
                    
                    if let error = error {
                        print("can't save heart rate")
                        print(error)
                    } else {
                        print("saved heart rate")
                    }
                }
                print("Successfully saved exercise sample")
            }
        }
        //---------------------SEEDING----------------------------------//
        
        store.getExerciseTime(){ (hours) in
            if hours.count > 0 {
                expectation.fulfill()
            } else {
                XCTFail()
            }
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testHealthStoreGetSleepHours() {
        let expectation = self.expectation(description: "got step count")
        let store:HealthStore = HealthStore.getInstance()
        
        //---------------------SEEDING----------------------------------//
        let appleStore:HKHealthStore = HKHealthStore()
        
        let start = Calendar.current.startOfDay(for: Date().addingTimeInterval(2))
        let end = start.addingTimeInterval(8*60*60)

        let sleepSample = HKCategorySample(type: HealthValues.sleepHours!, value: HKCategoryValueSleepAnalysis.inBed.rawValue, start: start, end: end)
        
        appleStore.save(sleepSample) { (success, error) in
            
            if let error = error {
                print("Error Saving step: \(error.localizedDescription)")
            } else {
                print("Successfully saved sleep sample")
            }
        }

        //---------------------SEEDING----------------------------------//
        
        store.getSleepHours(){ (hours) in
            if hours.count > 0 {
                expectation.fulfill()
            } else {
                XCTFail()
            }
        }
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testHealthStoreGetWorkouts() {
        let expectation = self.expectation(description: "got workouts")
        let store:HealthStore = HealthStore.getInstance()
        
        //---------------------SEEDING----------------------------------//
        let calorieQuantity = HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: 200)
        let distQuantity = HKQuantity(unit: HKUnit.mile(), doubleValue: 4)
        
        let workout = HKWorkout(activityType: .running,
                                start: Date(),
                                end: Date(),
                                duration: 1800,
                                totalEnergyBurned: calorieQuantity,
                                totalDistance: distQuantity,
                                device: HKDevice.local(),
                                metadata: nil)
        
        let appleStore:HKHealthStore = HKHealthStore()
        appleStore.save(workout) { (success, error) in
            
            if let error = error {
                print("Error Saving step: \(error.localizedDescription)")
            } else {
                var samples: [HKQuantitySample] = []
                let heartRateUnit = HKUnit(from: "count/min")
                let heartRateQuantity = HKQuantity(unit: heartRateUnit, doubleValue: 95)
                let heartRateQuantity2 = HKQuantity(unit: heartRateUnit, doubleValue: 96)
                let heartRateQuantity3 = HKQuantity(unit: heartRateUnit, doubleValue: 94)
                let heartRateForIntervalSample =
                    HKQuantitySample(type: HealthValues.heartRate!, quantity: heartRateQuantity,
                                     start: Date(), end: Date())
                let heartRateForIntervalSample2 =
                    HKQuantitySample(type: HealthValues.heartRate!, quantity: heartRateQuantity2,
                                     start: Date().addingTimeInterval(10), end: Date().addingTimeInterval(20))
                let heartRateForIntervalSample3 =
                    HKQuantitySample(type: HealthValues.heartRate!, quantity: heartRateQuantity3,
                                     start: Date().addingTimeInterval(20), end: Date().addingTimeInterval(30))
                samples.append(heartRateForIntervalSample)
                samples.append(heartRateForIntervalSample2)
                samples.append(heartRateForIntervalSample3)
                
                appleStore.add(samples, to: workout) {
                    (success, error) in
                    
                    if let error = error {
                        print("can't save heart rate")
                        print(error)
                    } else {
                        print("saved heart rate")
                    }
                }
                print("Successfully saved step sample")
            }
        }
        //---------------------SEEDING----------------------------------//
        
        store.getWorkouts() { (sample, error) in
            
            guard let samples = sample else {
                if let error = error {
                    print(error)
                    XCTFail()
                }
                return
            }
            if samples.count > 0 {
                expectation.fulfill()
            } else {
                XCTFail()
            }
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
}
