//
//  SleepAnalysisViewController.swift
//  projectCARE
//
//  Created by Cindy Lu on 2/20/18.
//  Copyright © 2018    q1 Ekta Shahani. All rights reserved.
//

import UIKit

class SleepAnalysisViewController: UIViewController {
    let store:HealthStore = HealthStore.getInstance()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let width = view.bounds.size.width
        let height = view.bounds.size.height
        var sleepData = [(title: String, graph: [(min: Double, max: Double)])]()
        var chart = generateCharts.createSleepActivityChart(groupsData: sleepData, horizontal: false, width: width, height: height)
        let group = DispatchGroup()
        group.enter()

        store.getExerciseTime() { activeTime in
            print("Exercise Time")
            for elm in activeTime {
                sleepData.append((title: elm.date, [(min: 0, max: elm.time)]))
            }
            print("Finish Exercise Time")
            group.leave()
        }
        print(sleepData)
        group.wait()
        
        print("Between both functions")
        
        group.enter()
        self.store.getSleepHours(){ hours in
            print("Sleep Hours")
            for elm in hours {
                for i in 0...6 {
                    if(sleepData[i].title == elm.date) {
                        sleepData[i].1.append((min: 0, max: elm.time))
                    }
                }
            }
            print(sleepData)

            print("Finish Sleep Hours")
            group.leave()
        }
        group.wait()

        print("Done with both async functions")
            //combine the data here

        let groupsData = sleepData
        chart = generateCharts.createSleepActivityChart(groupsData: groupsData, horizontal: false, width: width, height: height)
        view.addSubview(chart.view)
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
