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
    private let store:HealthStore?
    private var calorieGoal:Double = 0;
    
    public enum Zone {
        case peakZone
        case cardioZone
        case fatBurnZone
        case outOfZone
    }
    
    init() {
        self.store = HealthStore.getInstance()
        maxHR = 220 - (store?.getAge())!
        peakZone = Double(maxHR) * 0.85
        cardioZone = Double(maxHR) * 0.7
        fatBurnZone = Double(maxHR)  * 0.5
    }
    
    public func getCurrentZone(currHR:Double) -> Zone {
        if currHR >= peakZone {
            return Zone.peakZone
        } else if currHR >= cardioZone {
            return Zone.cardioZone
        } else if currHR >= fatBurnZone {
            return Zone.fatBurnZone
        }
        
        return Zone.outOfZone
    }
    
    public func getBestZone(workoutMins:Int) -> Zone {
        if workoutMins < 15 {
            return Zone.peakZone
        }
        else if workoutMins > 35 {
            return Zone.fatBurnZone;
        }
        return Zone.cardioZone
    }
    
    public func predictCalorieBurn(level:Int, workoutMins:Double, weight:Double) -> Double {
        var met:Double = 1;
        if level == 1 {
            met = 6;
        } else if level == 2 {
            met = 8;
        } else {
            met = 11;
        }
        
        calorieGoal = weight/2.2 * met * workoutMins/60
        
        return calorieGoal
        
        //ADITYA: see README.md
    }
    
    public func getPrevCalorieGoal() -> Double { return calorieGoal }
}
