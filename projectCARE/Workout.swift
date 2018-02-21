//
//  Workout.swift
//  projectCARE
//
//  Created by Ekta Shahani on 2/18/18.
//  Copyright © 2018 Ekta Shahani. All rights reserved.
//

import Foundation
import HealthKit

class Workout {
    public var avgHeartRate:Double = 0
    public var calsBurned:Double? = 0
    public var distTraveled:Double? = 0
    public var duration:Double = 0
    public var goalMet:Bool = false
    
    public var intensity:Int = 0
    public var userEnteredTime:Int = 0
    public var calorieBurnGoal:Double = 0
    
    private let hkworkout:HKWorkout
    private let store = HealthStore.getInstance()
    
    init(workout:HKWorkout) {
        hkworkout = workout
        self.duration = hkworkout.duration / 60.0
        self.distTraveled = (hkworkout.totalDistance?.doubleValue(for: HKUnit.mile()))
        self.calsBurned = (hkworkout.totalEnergyBurned?.doubleValue(for: HKUnit.kilocalorie()))
    }
    
//    public func setGoalValues() -> Void {
//        intensity = hkworkout.metadata?["IntensityLevel"] as! Int
//        userEnteredTime = hkworkout.metadata?["UserEnteredDuration"] as! Int
//        calorieBurnGoal = hkworkout.metadata?["CalorieBurnGoal"] as! Double
//    }
    
    public func queryAvgHR() -> Void {
        let predicateHR = HKQuery.predicateForObjects(from: hkworkout)
        let heartRateUnit = HKUnit(from: "count/min")
        
        let group = DispatchGroup()
        group.enter()
        
        store.getSamples(sampleType: HealthValues.heartRate!, predicate: predicateHR, limit: Int(HKObjectQueryNoLimit)) { (sample, error) in
            
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
            group.leave()
        }
        
        group.wait()
    }
    
    //use https://developer.apple.com/documentation/healthkit/hkobject/1615598-metadata
    public func setWorkoutGoalMet() -> Void {
        if(calsBurned != nil) {
            if calsBurned! >= calorieBurnGoal {
                goalMet = true
            }
        }
    }
}
