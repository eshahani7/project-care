//
//  Workout.swift
//  projectCARE
//
//  Created by Ekta Shahani on 2/18/18.
//  Copyright © 2018 Ekta Shahani. All rights reserved.
//

import Foundation

class Workout {
    private var avgHeartRate:Double = 0
    private var calsBurned:Double = 0
    private var distTraveled:Double = 0
    private var duration:Int = 0
    private var goalMet:Bool = false
    
    init(builder:WorkoutBuilder) {
        self.avgHeartRate = builder.avgHeartRate
        self.calsBurned = builder.calsBurned
        self.distTraveled = builder.distTraveled
        self.duration = builder.duration
        self.goalMet = builder.goalMet
    }
    
    public func getAvgHeartRate() -> Double {
        return avgHeartRate
    }
    
    public func getCalsBurned() -> Double {
        return calsBurned
    }
    
    public func getDistTraveled() -> Double {
        return distTraveled
    }
    
    public func getDuration() -> Int {
        return duration
    }
    
    public func wasGoalMet() -> Bool {
        return goalMet
    }
}
