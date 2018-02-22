//
//  ViewController.swift
//  projectCARE
//
//  Created by Ekta Shahani on 2/1/18.
//  Copyright © 2018 Ekta Shahani. All rights reserved.
//

import UIKit
import SwiftCharts

class ViewController: UIViewController {
    let store:HealthStore = HealthStore.getInstance()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var barsData = [(title: String, min: Int, max: Int)]()
        var i = 0
        
        let width = view.bounds.size.width
        let height = view.bounds.size.height
        
        var chart = generateCharts.createStepsChart(barsData: barsData, width: width, height: height)
        let group = DispatchGroup()
        group.enter()

        store.retrieveStepCount() { steps in
            for step in steps {
                i = i + 1
                barsData.append((title: String(i), min: 0, max: Int(step)))
            }
            chart = generateCharts.createStepsChart(barsData: barsData, width: width, height: height)
            group.leave()
        }
        group.wait()
        view.addSubview(chart.view)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
