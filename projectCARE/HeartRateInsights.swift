//
//  HeartRateInsights.swift
//  projectCARE
//
//  Created by Ekta Shahani on 2/25/18.
//  Copyright © 2018 Ekta Shahani. All rights reserved.
//

import Foundation
import HealthKit

class HeartRateInsights {
    
    private let store = HealthStore.getInstance()
    
    private var maxHR:Double?
    private var minHR:Double?
    private var avgHR:Double?
    
    private let heartRateUnit = HKUnit(from: "count/min")
    
    private let insights = ["Your resting heart rate is on the lower end - keep it up!",
                            "Your resting heart rate is just about average. With more activity, you can lower it.",
                            "Your resting heart rate is healthy, but on the higher end. Try adding at least 30 minutes of exercise 2-3 times a week to your routine.",
                            "Your resting heart rate is higher than healthy. You may want to add at least 30 minutes of exericse to your daily routine, or look into anxiety management techniques.",
                            "Error retrieving heart rate insights. Make sure heart rate is being measured by watch."]
    
    
    init() {
        let startDate = Date().addingTimeInterval(-24*60*60)
        let endDate = Date()
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictEndDate)
        
        let group = DispatchGroup()
        group.enter()
        store.getSamples(sampleType: HealthValues.heartRate!, predicate: predicate, limit: Int(HKObjectQueryNoLimit)) { (sample, error) in
            
            guard let samples = sample else {
                if let error = error {
                    print(error)
                }
                return
            }
            
            var max:Double = -1
            var min:Double = -1
            var avg:Double = -1
            for s in samples {
                let quantity = s.quantity.doubleValue(for: self.heartRateUnit)
                if quantity > max {
                    max = quantity
                }
                if min == -1 || quantity < min {
                    min = quantity
                }
                avg += quantity
            }
            
            if samples.count > 0 {
                avg /= Double(samples.count)
                self.avgHR = avg
                self.minHR = min
                self.maxHR = max
            }
            group.leave()
        }
        
        group.wait()
    }
    
    public func getMaxHR() -> Double? {
        return maxHR
    }
    
    public func getMinHR() -> Double? {
        return minHR
    }
    
    public func getAvgHR() -> Double? {
        return avgHR
    }
    
    public func getInsights() -> String {
        if avgHR == nil {
            return insights[4]
        }
        
        if avgHR! <= 70 {
            return insights[0]
        } else if avgHR! <= 85 {
            return insights[1]
        } else if avgHR! <= 100 {
            return insights[2]
        }
        
        return insights[3]
    }
}
