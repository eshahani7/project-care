//
//  WorkoutList.swift
//  projectCARE
//
//  Created by Ekta Shahani on 2/18/18.
//  Copyright © 2018 Ekta Shahani. All rights reserved.
//

import Foundation
import HealthKit

class WorkoutList {
    private var workouts = [Workout]()
    private let store = HealthStore.getInstance()
    
    public func getWorkoutList() -> [Workout] {
        let group = DispatchGroup()
        group.enter()
        
        store.getWorkouts() { (sample, error) in
            
            guard let samples = sample else {
                if let error = error {
                    print(error)
                }
                return
            }
            for s in samples {
                let builder = WorkoutBuilder(workout: s)
                let w = builder.build()
                self.workouts.append(w)
            }
            group.leave()
            
        }
        
        group.wait()
        return workouts
    }
}

