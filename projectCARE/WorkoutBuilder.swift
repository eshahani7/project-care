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
    public var duration:Int = 0
    public var goalMet:Bool = false
    
    private let hkworkout:HKWorkout
    
    init(workout:HKWorkout) {
        hkworkout = workout
    }
    
    
}
