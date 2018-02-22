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
