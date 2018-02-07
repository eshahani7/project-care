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
    let maxHR:Int?
    let store:HealthStore?
    
    init(store:HealthStore) {
        self.store = store
        maxHR = 220 - store.getAge()
    }
    
    
}
