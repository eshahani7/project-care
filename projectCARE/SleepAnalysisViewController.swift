//
//  SleepAnalysisViewController.swift
//  projectCARE
//
//  Created by Cindy Lu on 2/20/18.
//  Copyright © 2018    q1 Ekta Shahani. All rights reserved.
//

import UIKit
import Charts

class SleepAnalysisViewController: UIViewController {
    let store:HealthStore = HealthStore.getInstance()
    
    var sleepActivityChart = BarChartView(frame: CGRect(x: 25, y: 200, width: 325, height: 350))
    
    var sleepData : [(title: String, graph: [Double])] = []
    var activityData : [(title: String, graph: [Double])] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //gradient background
        let layer = CAGradientLayer()
        layer.frame = CGRect(x: 0, y: -20, width: 500, height: 600)
        layer.colors = [UIColor.black.cgColor, UIColor(red: 0.2196, green: 0.2588, blue: 0.3882, alpha: 1.0)]
        view.layer.addSublayer(layer)
        
        //STEP label
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 25))
        label.center = CGPoint(x: 190, y: 170)
        label.textAlignment = .center
        label.text = "Sleep Analysis"
        label.font = UIFont(name:"Helvetica", size: 15.0)
        label.textColor = UIColor(red: 0.8902, green: 0.902, blue: 0.9137, alpha: 0.75)
        self.view.addSubview(label)
        
        //sleep analysis chart
        let group = DispatchGroup()
        group.enter()
        store.getExerciseTime() { activeTime in
            for elm in activeTime {
                self.activityData.append((title: elm.date, graph: [(elm.time)]))
            }
            group.leave()
        }
        group.wait()
        group.enter()
        self.store.getSleepHours(){ hours in
            for elm in hours {
                self.sleepData.append((title: elm.date, graph: [(elm.time)]))
            }
            group.leave()
        }
        group.wait()
        generateCharts.updateSleepActivityGraph(sleepData: sleepData, activityData: activityData, chart: sleepActivityChart)
        view.addSubview(sleepActivityChart)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
