//
//  WorkoutSessionViewController.swift
//  projectCARE
//
//  Created by Cindy Lu on 2/20/18.
//  Copyright © 2018 Ekta Shahani. All rights reserved.
//

import UIKit
import HealthKit

class WorkoutSessionViewController: UIViewController {

    
    let store:HealthStore = HealthStore.getInstance()
    let wl:WorkoutList = WorkoutList()
    var index:Int=0
    
    @IBOutlet weak var AvgHeartRate: UILabel!
    @IBOutlet weak var CaloriesBurned: UILabel!
    //@IBOutlet weak var DistTraveled: UILabel!
    @IBOutlet weak var Duration: UILabel!
    @IBOutlet weak var WorkoutDate: UILabel!
    @IBOutlet weak var GoalMet: UILabel!
    @IBOutlet weak var UserEnteredTime: UILabel!
    @IBOutlet weak var CalBurnGoal: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let list:[WorkoutFacade] = wl.getWorkoutList()
        let mapThis:WorkoutFacade = list[index]
        
        print(String(mapThis.getCalorieBurnGoal() ))
        //charts
        let width = view.bounds.size.width
        let height = view.bounds.size.height
        var pointsData = mapThis.getHRTuples()
        
        var chart = generateCharts.createWorkoutChart(pointsData: pointsData, width: width, height: height)
        view.addSubview(chart.view)
        
        let av = "♥ Average Heart Rate: " + String(format: "%.2f", mapThis.getAvgHeartRate()) + " BPM"
        let cal = "♥ Calories Burned: " + String(describing: mapThis.getCalsBurned()!) + " CAL"
        let du = "♥ Duration: " + durationToString(min:mapThis.getDuration())
        let da = dateFormate(date: mapThis.getWorkoutDate())
        let calb = "♥ Calorie Burn Goal: " + String(format: "%.2f", mapThis.getCalorieBurnGoal())
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
        GoalMet.text = "♥ Goal Met: " + goal
        UserEnteredTime.text = "♥ Time Entered: " + minToString(min:mapThis.getUserEnteredTime())
        CalBurnGoal.text = calb + " CAL"
        
        
//        var myMutableString = NSMutableAttributedString()
//        myMutableString = NSMutableAttributedString(string: av as String, attributes: [NSAttributedStringKey.font:UIFont(name: "System", size: 18.0)!])
//
//        myMutableString.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 23.0), range: NSRange(location:22,length:(String(mapThis.getAvgHeartRate()).count)))
//        AvgHeartRate.attributedText = myMutableString
        
        // Do any additional setup after loading the view.
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
