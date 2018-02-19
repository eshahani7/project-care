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
    private var duration:Double = 0
    private var goalMet:Bool = false
    
    private var userEnteredTime:Int = 0
    private var calorieBurnGoal:Double = 0
    
    init(builder:WorkoutBuilder) {
        self.avgHeartRate = builder.avgHeartRate
        self.calsBurned = builder.calsBurned
        self.distTraveled = builder.distTraveled
        self.duration = builder.duration
        self.goalMet = builder.goalMet
        
        self.userEnteredTime = builder.userEnteredTime
        self.calorieBurnGoal = builder.calorieBurnGoal
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
    
    public func getDuration() -> Double {
        return duration
    }
    
    public func wasGoalMet() -> Bool {
        return goalMet
    }
    
    public func getUserEnteredTime() -> Int {
        return userEnteredTime
    }
    
    public func getCalorieBurnGoal() -> Double {
        return calorieBurnGoal
    }
}
