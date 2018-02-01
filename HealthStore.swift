//
//  HealthStore.swift
//  projectCARE
//
//  Created by Ekta Shahani on 2/1/18.
//  Copyright © 2018 Ekta Shahani. All rights reserved.
//

import Foundation
import HealthKit

class HealthStore {
    let store: HKHealthStore?
    
    init() {
        if HKHealthStore.isHealthDataAvailable() {
            store = HKHealthStore();
        } else {
            store = nil;
            //throw an error
        }
    }
}
