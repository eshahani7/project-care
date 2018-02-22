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
    @IBOutlet weak var DistTraveled: UILabel!
    @IBOutlet weak var Duration: UILabel!
    @IBOutlet weak var WorkoutDate: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let list:[WorkoutFacade] = wl.getWorkoutList()
        let mapThis:WorkoutFacade = list[index]
        
        AvgHeartRate.text = String(mapThis.getAvgHeartRate())
        CaloriesBurned.text = String(describing: mapThis.getCalsBurned())
        DistTraveled.text = String(describing: mapThis.getDistTraveled())
        Duration.text = String(mapThis.getDuration())
        WorkoutDate.text = String(describing: mapThis.getWorkoutDate())
        
        
        
        // Do any additional setup after loading the view.
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
