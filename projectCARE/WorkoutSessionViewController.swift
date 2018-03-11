//
//  WorkoutSessionViewController.swift
//  projectCARE
//
//  Created by Cindy Lu on 2/20/18.
//  Copyright © 2018 Ekta Shahani. All rights reserved.
//

import UIKit
import HealthKit
import Charts

class WorkoutSessionViewController: UIViewController {

    
    let store:HealthStore = HealthStore.getInstance()
    let wl:WorkoutList = WorkoutList()
    var index:Int=0
    
    @IBOutlet weak var AvgHeartRate: UILabel!
    @IBOutlet weak var CaloriesBurned: UILabel!
    @IBOutlet weak var Duration: UILabel!
    @IBOutlet weak var WorkoutDate: UILabel!
    @IBOutlet weak var GoalMet: UILabel!
    @IBOutlet weak var UserEnteredTime: UILabel!
    @IBOutlet weak var CalBurnGoal: UILabel!
    
    @IBOutlet weak var gradientB: UIImageView!
    
    var gradientLayer: CAGradientLayer!
    
    func createGradientLayer() {
        gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.view.bounds
        
        gradientLayer.colors = [UIColor.red.cgColor, UIColor.yellow.cgColor]
        gradientLayer.startPoint = CGPoint(x:0.0, y:0.0)
        gradientLayer.endPoint = CGPoint(x:1.0, y:1.0)
        
        self.view.layer.addSublayer(gradientLayer)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        let list:[WorkoutFacade] = wl.getWorkoutList()
        let mapThis:WorkoutFacade = list[index]
        print(String(mapThis.getCalorieBurnGoal() ))
        
        //charts
        //@CINDY - you can edit size if you want
        let HRTimeChart = ScatterChartView(frame: CGRect(x: 25, y: 180, width: 330, height: 230))
        let pointsData = mapThis.getHRTuples()
        print(pointsData)
        
        generateCharts.updateHRWorkoutGraph(data: pointsData, chart: HRTimeChart)
        view.addSubview(HRTimeChart)
    
        let av = String(format: "%.2f", mapThis.getAvgHeartRate()) + " BPM"
        let cal = String(format: "%.2f", mapThis.getCalsBurned()!) + " CAL"
        let du =  durationToString(min:mapThis.getDuration())
 

        let da = dateFormate(date: mapThis.getWorkoutDate())
        let calb = String(format: "%.2f", mapThis.getCalorieBurnGoal())
        var goal = ""
        if(mapThis.wasGoalMet()) {
            goal = "YES"
        } else {
            goal = "NO"
        }
        
        AvgHeartRate.text = av
        CaloriesBurned.text = cal
        //DistTraveled.text = String(describing: mapThis.getDistTraveled())
        Duration.text = du
        WorkoutDate.text = da
        GoalMet.text = goal
        UserEnteredTime.text =  minToString(min:mapThis.getUserEnteredTime())
        CalBurnGoal.text = calb + " CAL"
    }
    
    func durationToString(min:Double) -> String {
        let mins = Int(floor(min))
        let secs = Int(floor(min * 60).truncatingRemainder(dividingBy: 60))
        
        return String(format:"%02d:%02d", mins, secs)
    }
    func minToString(min:Double) -> String {
        let mins = Int(floor(min))
        
        return String(format:"%02d minutes", mins)
    }
    
    func dateFormate(date:Date) -> String {
        let dateWithTime = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        
        let date = dateFormatter.string(from: date) // 2/10/17
        return date
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
