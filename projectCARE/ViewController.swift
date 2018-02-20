//
//  ViewController.swift
//  projectCARE
//
//  Created by Ekta Shahani on 2/1/18.
//  Copyright © 2018 Ekta Shahani. All rights reserved.
//

import UIKit
import WatchConnectivity
import HealthKit

class ViewController: UIViewController{
    
    //MARK: Properties
    
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var startWorkoutButton: UIButton!
    
    let store:HealthStore = HealthStore.getInstance()
    
//    private func authorizeHealthKit() {
//        HealthStore.authorizeHealthKit { (authorized, error) in
//
//            guard authorized else {
//
//                let baseMessage = "HealthKit Authorization Failed"
//
//                if let error = error {
//                    print("\(baseMessage). Reason: \(error.localizedDescription)")
//                } else {
//                    print(baseMessage)
//                }
//
//                return
//            }
//
//            print("HealthKit Successfully Authorized.")
//        }
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //authorizeHealthKit()
        
//        var session: WCSession?
//        if WCSession.isSupported() {
//            session = WCSession.default()
//            session?.delegate = self as? WCSessionDelegate
//            session?.activate()
//        }
        
        print(store.getAge())
        print(store.getBiologicalSex()) //need a toString
        
        var steps = 0.0
        
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)

        print ("Getting steps.")
        store.getSamples(sampleType: HKObjectType.quantityType(forIdentifier: .stepCount)!,
                        startDate: startOfDay, endDate: now) { (samples, error) in
            guard let samples = samples else {
                if let error = error {
                    print(error)
                }
                return
            }
            
            for sample in samples{
                steps += sample.quantity.doubleValue(for: HKUnit.count())
                print("Steps: \(steps)")
            }
            print("Got steps.")
            self.stepLabel.text = "Steps: \(steps)"
        }
    }
    
    //MARK: Actions
    
    @IBAction func startWorkoutButtonPressed(_ sender: Any) {
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
