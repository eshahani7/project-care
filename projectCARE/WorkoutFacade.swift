//
//  WorkoutFacade.swift
//  projectCARE
//
//  Created by Ekta Shahani on 2/19/18.
//  Copyright © 2018 Ekta Shahani. All rights reserved.
//

import Foundation
import HealthKit

class WorkoutFacade {
    
    private let workout:Workout
    
    init(w:HKWorkout) {
        self.workout = Workout(workout: w)
        //workout.setGoalValues()
    }
    
    //Cindy: don't display if -1 returned
    public func getAvgHeartRate() -> Double {
        workout.queryAvgHR()
        if(workout.avgHeartRate > 0) {
            return workout.avgHeartRate
        }
        return -1
    }
    
    public func getCalsBurned() -> Double? {
        return workout.calsBurned
    }
    
    public func getDistTraveled() -> Double? {
        return workout.distTraveled
    }
    
    public func getDuration() -> Double {
        return workout.duration
    }
    
    //Cindy: will have to look up how to format a date to display
    public func getWorkoutDate() -> Date {
        return workout.dateOfWorkout
    }
    
    public func getHRTuples() -> [(heartRate: Double, timeSinceStart:Double)] {
        if !workout.isHRAvailable() {
            self.getAvgHeartRate()
        }
        workout.constructTimeSamples()
        return workout.hrTuples
    }
    
    //-----these don't work yet-------//
    public func wasGoalMet() -> Bool {
        workout.setWorkoutGoalMet()
        return workout.goalMet
    }
    
    public func getUserEnteredTime() -> Int {
        return workout.userEnteredTime
    }
    
    public func getCalorieBurnGoal() -> Double {
        return workout.calorieBurnGoal
    }
    
}
