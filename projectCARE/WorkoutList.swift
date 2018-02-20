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
    private var workouts = [WorkoutFacade]()
    private let store = HealthStore.getInstance()
    
    public func getWorkoutList() -> [WorkoutFacade] {
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
                let workout = Workout(workout: s)
                let w = WorkoutFacade(w: workout)
                self.workouts.append(w)
            }
            group.leave()
            
        }
        
        group.wait()
        return workouts
    }
}

