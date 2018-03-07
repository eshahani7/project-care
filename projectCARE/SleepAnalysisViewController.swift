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
    
    @IBOutlet weak var maxSleep: UILabel!
    @IBOutlet weak var minSleep: UILabel!
    @IBOutlet weak var avgSleep: UILabel!
    @IBOutlet weak var sleepInsights: UILabel!
    
    @IBOutlet weak var maxActivity: UILabel!
    @IBOutlet weak var minActivity: UILabel!
    @IBOutlet weak var avgActivity: UILabel!
    @IBOutlet weak var activityInsights: UILabel!
    
    let SAI:SleepActivityInsights = SleepActivityInsights()
    
    let store:HealthStore = HealthStore.getInstance()
    

    var sleepActivityChart = BarChartView(frame: CGRect(x: 25, y: 200, width: 330, height: 300))

    
    var sleepData : [(title: String, graph: [Double])] = []
    var activityData : [(title: String, graph: [Double])] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  RICHA: FIX   error:'Unable to parse factorization string count/hour'
//        maxSleep.text = String(describing: SAI.getMaxSleep())
//        minSleep.text = String(describing: SAI.getMinSleep())
//        avgSleep.text = String(describing: SAI.getAvgSleep())
//        sleepInsights.text = SAI.getSleepInsights()
//        maxActivity.text = String(describing: SAI.getMaxActivity())
//        minActivity.text = String(describing: SAI.getMinActivity())
//        avgActivity.text = String(describing: SAI.getAvgActivity())
//        activityInsi ghts.text = SAI.getActivityInsights()
        
        
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
