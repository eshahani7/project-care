//
//  WorkoutUtilities.swift
//  projectCARE
//
//  Created by Ekta Shahani on 2/13/18.
//  Copyright © 2018 Ekta Shahani. All rights reserved.
//

import Foundation
import HealthKit

class WorkoutUtilities {
    private var maxHR:Int = 0
    private var peakZone:Double = 0
    private var cardioZone:Double = 0
    private var fatBurnZone:Double = 0
    private var outOfZone:Double = 0
    
    private let store:HealthStore?
    private var calorieGoal:Double = 0
    private var workoutMins:Double
    private var intensityLevel:Int
    
    public enum Zone {
        case peakZone
        case cardioZone
        case fatBurnZone
        case outOfZone
    }
    
    init(workoutMins:Double, intensityLevel:Int) {
        self.store = HealthStore.getInstance()
        maxHR = 220 - (store?.getAge())!
        peakZone = Double(maxHR) * 0.85
        cardioZone = Double(maxHR) * 0.7
        fatBurnZone = Double(maxHR)  * 0.5
        
        self.workoutMins = workoutMins
        self.intensityLevel = intensityLevel
    }
    
    public func isTooSlow(currHR:Double) -> Bool {
        return getCurrentZone(currHR: currHR) < getBestZone()
    }
    
    public func isTooFast(currHR:Double) -> Bool {
        return getCurrentZone(currHR: currHR) > getBestZone()
    }
    
    public func predictCalorieBurn(weight:Double) -> Double {
        var met:Double = 1;
        if intensityLevel == 1 {
            met = 6;
        } else if intensityLevel == 2 {
            met = 8;
        } else {
            met = 11;
        }
        
        calorieGoal = weight/2.2 * met * workoutMins/60
        
        return calorieGoal
        
        //ADITYA: see README.md
    }
    
    public func getPrevCalorieGoal() -> Double { return calorieGoal }
    
    private func getBestZone() -> Double {
        if workoutMins < 15 {
            return peakZone
        }
        else if workoutMins > 35 {
            return fatBurnZone
        }
        return cardioZone
    }
    
    private func getCurrentZone(currHR:Double) -> Double {
        if currHR >= peakZone {
            return peakZone
        } else if currHR >= cardioZone {
            return cardioZone
        } else if currHR >= fatBurnZone {
            return fatBurnZone
        }
        
        return outOfZone
    }
}
