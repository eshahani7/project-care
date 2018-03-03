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
    
    var sleepActivityChart = BarChartView(frame: CGRect(x: 40, y: 120, width: 300, height: 300))
    var sleepActivityData : [(title: String, graph: [Double])] = []
    
    var sleepChart = BarChartView(frame: CGRect(x: 40, y: 350, width: 300, height: 300))
    var sleepData : [(title: String, graph: [Double])] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        let group = DispatchGroup()
        group.enter()
        store.getExerciseTime() { activeTime in
            print(activeTime.count)
            for elm in activeTime {
                self.sleepActivityData.append((title: elm.date, [(elm.time)]))
            }
            group.leave()
        }
        group.wait()
        group.enter()
        self.store.getSleepHours(){ hours in
            for elm in hours {
                print(elm)
                self.sleepActivityData.append((title: elm.date, graph: [(elm.time)]))
//                for i in 0...4 {
//                    if(self.sleepActivityData[i].title == elm.date) {
//                        self.sleepActivityData[i].1.append((elm.time))
//                    }
//                }
            }
            group.leave()
        }
        group.wait()
        generateCharts.updateSleepActivityGraph(data: sleepActivityData, chart: sleepActivityChart)
        view.addSubview(sleepActivityChart)
        
        
        var sleepChart = BarChartView(frame: CGRect(x: 40, y: 350, width: 300, height: 300))
        
        var sleepData : [(title: String, graph: [Double])] = []
        
            store.getSleepHours(){ hours in
                for elm in hours {
                     print("hello ")
                    print(elm)
                    sleepData.append((title: elm.date, graph: [(elm.time)]))
                }
            }
            print("sleep data ")
            print(sleepData)
        
            generateCharts.updateSleepGraph(data: sleepData, chart: sleepChart)
            view.addSubview(sleepChart)
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
