//
//  ViewController.swift
//  projectCARE
//
//  Created by Ekta Shahani on 2/1/18.
//  Copyright © 2018 Ekta Shahani. All rights reserved.
//

import UIKit
import HealthKit

class ViewController: UIViewController {
    
    let store:HealthStore = HealthStore.getInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
  
        print(store.getAge())
        print(store.getBiologicalSex()) //need a toString
        
        store.getSamples(sampleType: HealthValues.stepCount!, startDate: Date().addingTimeInterval(-86400), endDate: Date()) { (sample, error) in
            
            guard let sample = sample else {
                if let error = error {
                    print(error)
                }
                return
            }

            for s in sample {
                print(s.quantity)
            }
            print(sample)
        }
        
        let wu:WorkoutUtilities = WorkoutUtilities(store: store)
//        let cals = wu.predictCalorieBurn(level: 3, workoutMins: 20)
//        print(cals)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

