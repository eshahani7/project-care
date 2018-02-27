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
    private var weight:Double?
    private var warmUp:Double
    private var coolDown:Double
    
    init(workoutMins:Double, intensityLevel:Int) {
        self.store = HealthStore.getInstance()
        maxHR = 220 - (store?.getAge())!
        peakZone = Double(maxHR) * 0.85
        cardioZone = Double(maxHR) * 0.7
        fatBurnZone = Double(maxHR)  * 0.5
        warmUp = workoutMins * 0.2
        coolDown = workoutMins - (workoutMins * 0.2)
        self.workoutMins = workoutMins
        self.intensityLevel = intensityLevel
    }
    
    public func isTooSlow(currHR:Double, startDate:Date) -> Bool {
        let timePassed = Date().timeIntervalSinceNow
        print("Zone: \(getBestZone(timePassed: timePassed))")
        
        return getCurrentZone(currHR: currHR) < getBestZone(timePassed: timePassed)
    }
    
    public func isTooFast(currHR:Double, startDate:Date) -> Bool {
        let timePassed = Date().timeIntervalSinceNow
        print("Zone: \(getBestZone(timePassed: timePassed))")
        
        return getCurrentZone(currHR: currHR) > getBestZone(timePassed: timePassed)
    }
    
    public func predictCalorieBurn() -> Double {
        let group = DispatchGroup()
        group.enter()
        
        store?.getSamples(sampleType: HealthValues.bodyMass!, startDate: Date().addingTimeInterval(-60*60*24*7), endDate: Date()) { (sample, error) in
            
            guard let samples = sample else {
                if let error = error {
                    print(error)
                }
                return
            }
            
            //samples is an array, use to pass into another function or whatever you need
            if samples.count > 0 {
                self.weight = samples[samples.count-1].quantity.doubleValue(for: HKUnit.pound())

            }
            group.leave()
        }
        
        group.wait()
        
        var met:Double = 1;
        if intensityLevel == 1 {
            met = 6;
        } else if intensityLevel == 2 {
            met = 8;
        } else {
            met = 11;
        }
        
        calorieGoal = weight!/2.2 * met * workoutMins/60
        
        return calorieGoal
    }
    
    public func getPrevCalorieGoal() -> Double { return calorieGoal }
    
    private func getBestZone(timePassed:Double) -> Double {
        if timePassed <= warmUp || timePassed >= coolDown{
            if workoutMins < 15 {
                return peakZone*0.80
            }
            else if workoutMins > 35 {
                return fatBurnZone*0.95
            }
            return cardioZone*0.80
        }
        else{
            if workoutMins < 15 {
                return peakZone
            }
            else if workoutMins > 35 {
                return fatBurnZone
            }
            return cardioZone
        }
    }
    
    private func getCurrentZone(currHR:Double) -> Double {
        if currHR >= peakZone && currHR <= Double (maxHR) {
            return peakZone
        } else if currHR >= cardioZone {
            return cardioZone
        } else if currHR >= fatBurnZone {
            return fatBurnZone
        }
        
        return outOfZone
    }
}
