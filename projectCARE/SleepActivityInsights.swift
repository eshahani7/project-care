//
//  SleepActivityInsights.swift
//  projectCARE
//
//  Created by admin on 3/3/18.
//  Copyright © 2018 Ekta Shahani. All rights reserved.
//

import Foundation
import HealthKit
class SleepActivityInsights {
    private let store = HealthStore.getInstance()
    
    private var maxSleep:Double?
    private var minSleep:Double?
    private var avgSleep:Double?
    
    private var maxActivity:Double?
    private var minActivity:Double?
    private var avgActivity:Double?
    
//    private let sleepUnit = HKUnit(from: "count/hour")
//    private let activityUnit = HKUnit(from: "count/hour")
    
    private let sleepInsights = ["Your sleep time for the week is way below average. You need to sleep more!",
                            "Your sleep time for the week is just about average. With more activity, you can increase it.",
                            "Your sleep time is healthy. Great job!",
                            "Error retrieving sleepInsights."]
    
    private let activityInsights = ["Your active time for the week is low. You need to exercise more!",
                                 "Your active time for the week is just about average. You can exercise a bit more to get better sleep",
                                 "Your active time is healthy. Great job!",
                                 "Error retrieving activityInsights."]
    
    init() {
        let group = DispatchGroup()
        group.enter()
        store.getExerciseTime() { activeTime in
            var max:Double = -1
            var min:Double = -1
            var avg:Double = -1
            
            for elm in activeTime {
                let quantity = elm.time
                if quantity > max {
                    max = quantity
                }
                if min == -1 || quantity < min {
                    min = quantity
                }
                avg += quantity
            }
            if(activeTime.count != 0) {
                avg /= Double(activeTime.count)
                self.avgActivity = avg
                self.minActivity = min
                self.maxActivity = max
            }
            group.leave()
        }
        group.wait()
        group.enter()
        self.store.getSleepHours(){ hours in
            var max:Double = -1
            var min:Double = -1
            var avg:Double = -1
            
            for elm in hours {
                let quantity = elm.time
                if quantity > max {
                    max = quantity
                }
                if min == -1 || quantity < min {
                    min = quantity
                }
                avg += quantity
            }
            if(hours.count != 0) {
                avg /= Double(hours.count)
                self.avgSleep = avg
                self.minSleep = min
                self.maxSleep = max
            }
            group.leave()
        }
        group.wait()
    }
    
    public func getMaxSleep() -> Double? {
        if((maxSleep) != nil) {
            return maxSleep
        }
        return 0;
    }
    
    public func getMinSleep() -> Double? {
        if((minSleep) != nil) {
            return minSleep
        }
        return 0;
    }
    
    public func getAvgSleep() -> Double? {
        if((avgSleep) != nil) {
            return avgSleep
        }
        return 0;
    }
    
    public func getMaxActivity() -> Double? {
        if((maxActivity) != nil) {
            return maxActivity
        }
        return 0;
    }
    
    public func getMinActivity() -> Double? {
        if((minActivity) != nil) {
            return minActivity
        }
        return 0;
    }
    
    public func getAvgActivity() -> Double? {
        if((avgActivity) != nil) {
            return avgActivity
        }
        return 0;
    }
    
    public func getSleepInsights() -> String {
        if avgSleep == nil{
            return sleepInsights[3]
        }

        if avgSleep! <= 6 {
            return sleepInsights[0]
        } else if avgSleep! <= 7 {
            return sleepInsights[1]
        }
        return sleepInsights[2]
    }
    
    public func getActivityInsights() -> String {
        if avgActivity == nil{
            return activityInsights[3]
        }
        if avgActivity! <= 0.2 {
            return activityInsights[0]
        } else if avgActivity! <= 0.5 {
            return activityInsights[1]
        }
        return activityInsights[2]
    }
}
