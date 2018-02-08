//
//  HRCalculations.swift
//  projectCARE
//
//  Created by Ekta Shahani on 2/6/18.
//  Copyright © 2018 Ekta Shahani. All rights reserved.
//

import Foundation
import HealthKit

class HRCalculations {
    var maxHR:Int = 0
    let restingHR:Int?
    var peakZone:Double = 0
    var cardioZone:Double = 0
    var fatBurnZone:Double = 0
    let outOfZone:Double = 0
    let store:HealthStore?
    
    init(store:HealthStore) {
        self.store = store
        maxHR = 220 - store.getAge()
        peakZone = Double(maxHR) * 0.85
        cardioZone = Double(maxHR) * 0.7
        fatBurnZone = Double(maxHR)  * 0.5
        //init restingHR by sampling and averaging HR over 24 hours
        
    }
    
    func inPeakZone(currHR:Double) -> Bool {
        return currHR >= peakZone
    }
    
    func inCardioZone(currHR:Double) -> Bool {
        return currHR >= cardioZone && currHR < peakZone
    }
    
    func inFatBurnZone(currHR:Double) -> Bool {
        return currHR >= fatBurnZone && currHR < cardioZone
    }
    
    func calcBestZone(workoutMins:Int) -> Int {
        if workoutMins < 20 {
            return 85;
        }
        else if workoutMins > 30 {
            return 50;
        }
        return 70;
    }
    
    
}
