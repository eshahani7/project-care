//
//  WorkoutBuilder.swift
//  projectCARE
//
//  Created by Ekta Shahani on 2/18/18.
//  Copyright © 2018 Ekta Shahani. All rights reserved.
//

import Foundation
import HealthKit

class WorkoutBuilder {
    public var avgHeartRate:Double = 0
    public var calsBurned:Double = 0
    public var distTraveled:Double = 0
    public var duration:Double = 0
    public var goalMet:Bool = false
    
    private let hkworkout:HKWorkout
    private let store = HealthStore.getInstance()
    
    init(workout:HKWorkout) {
        hkworkout = workout
        self.duration = hkworkout.duration / 60.0
        self.distTraveled = (hkworkout.totalDistance?.doubleValue(for: HKUnit.mile()))!
        self.calsBurned = (hkworkout.totalEnergyBurned?.doubleValue(for: HKUnit.kilocalorie()))!
    }
    
//    public func setGoalsMet() -> WorkoutBuilder {
//        
//    }
    
    public func calculateAvgHR() -> Void {
        let predicateHR = HKQuery.predicateForObjects(from: hkworkout)
        let heartRateUnit = HKUnit(from: "count/min")
        store.getSamples(sampleType: HealthValues.bodyMass!, predicate: predicateHR, limit: Int(HKObjectQueryNoLimit)) { (sample, error) in
            
            guard let samples = sample else {
                if let error = error {
                    print(error)
                }
                return
            }
            
            var avg:Double = 0
            for s in samples {
                avg += s.quantity.doubleValue(for: heartRateUnit)
            }
            
            avg /= Double(samples.count)
            self.avgHeartRate = avg
        }
    }
    
}
