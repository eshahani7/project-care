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
    
    private let sleepActivityInsights =
        ["Your sleep time for the week is way below average. Your active hours for the week are also below average. Try to increase your exercise time to improve your sleep.",
         "Your active hours for the week look good, but you're not getting enough sleep. Try to increase the intensity of your workouts, and listen to guided meditaion before going to bed.",
         "Your sleep time for the week is just about average. With more activity, you can increase the duration of your sleep.",
         "You're not exercising enough. Try to exercise at least 3 times a week for 30 minutes each day.",
         "Your active time for the week is just about average. You can exercise a bit more to get better sleep",
         "You're getting lots of sleep and exercise! Great job!",
         "Error retrieving Insights."
        ]
    
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
                avg /= 7.0
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
                avg /= 7.0
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
    
    public func getSleepActivityInsights() -> String {
        print("Average sleep: " + String(describing: avgSleep!))
        if (avgSleep == nil && avgActivity == nil) {
            return sleepActivityInsights[6]
        }
        if (avgSleep! <= 6.0 && avgActivity! < 1) {
            return sleepActivityInsights[0]
        }
        if (avgSleep! <= 6 && avgActivity! >= 1) {
            return sleepActivityInsights[1]
        }
        if (avgSleep! >= 5.6 && avgSleep! <= 7.5 && avgActivity! <= 1) {
            return sleepActivityInsights[2]
        }
        if (avgActivity! <= 0.7) {
            return sleepActivityInsights[3]
        }
        if (avgActivity! > 0.7 && avgActivity! <= 1.3) {
            return sleepActivityInsights[4]
        }
        return sleepActivityInsights[5]
    }

}
