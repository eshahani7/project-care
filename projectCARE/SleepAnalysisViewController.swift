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
    
    var sleepActivityData : [(title: String, graph: [Double])] = []
    
    var sleepChart = BarChartView(frame: CGRect(x: 40, y: 350, width: 300, height: 300))
    var sleepData2 : [(title: String, graph: [Double])] = []

    var sleepActivityChart = BarChartView(frame: CGRect(x: 40, y: 120, width: 300, height: 400))
    
    var sleepData : [(title: String, graph: [Double])] = []
    var activityData : [(title: String, graph: [Double])] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        let group = DispatchGroup()
        group.enter()
        store.getExerciseTime() { activeTime in
            for elm in activeTime {
                self.activityData.append((title: elm.date, graph: [(elm.time)]))
            }
            print("Done printing active elms")
            group.leave()
        }
        group.wait()
        group.enter()
        self.store.getSleepHours(){ hours in
            for elm in hours {
//                var found = false
                self.sleepData.append((title: elm.date, graph: [(elm.time)]))
//                for i in 0...self.activityData.count {
//                    if(self.sleepData[i].title == elm.date) {
//                        self.sleepData[i].1.append((elm.time))
//                    }
//                }
            }
            print("Done printing sleep data")
            print(self.activityData)
            print("Done printing activity data")
            print(self.sleepData)
            group.leave()
        }
//        print(sleepActivityData)
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
