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
    
    public func getAvgHeartRate() -> Double {
        workout.queryAvgHR()
        return workout.avgHeartRate
    }
    
    public func getCalsBurned() -> Double {
        if(workout.calsBurned != nil) {
            return workout.calsBurned!
        }
        return 0
    }
    
    public func getDistTraveled() -> Double {
        if(workout.distTraveled != nil) {
            return workout.distTraveled!
        }
        return 0
    }
    
    public func getDuration() -> Double {
        return workout.duration
    }
    
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
