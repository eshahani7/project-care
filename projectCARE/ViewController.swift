//
//  ViewController.swift
//  projectCARE
//
//  Created by Ekta Shahani on 2/1/18.
//  Copyright © 2018 Ekta Shahani. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let store:HealthStore = HealthStore.getInstance()
    
    
    @IBAction func SleepAnalysis(_ sender: UIButton) {
        performSegue(withIdentifier: "SleepAnalysis", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

