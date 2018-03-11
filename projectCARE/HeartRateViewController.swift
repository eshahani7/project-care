//
//  HeartRateViewController.swift
//  projectCARE
//
//  Created by Cindy Lu on 3/3/18.
//  Copyright © 2018 Ekta Shahani. All rights reserved.
//

import UIKit

class HeartRateViewController: UIViewController {

    @IBOutlet weak var avg: UILabel!
    @IBOutlet weak var min: UILabel!
    @IBOutlet weak var max: UILabel!
    @IBOutlet weak var insights: UILabel!
    
    let store:HealthStore = HealthStore.getInstance()
    let HR:HeartRateInsights = HeartRateInsights()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let av = String(format: "%.0f", HR.getAvgHR()!) + " BPM"
        let mi = String(format: "%.0f", HR.getMinHR()!) + " BPM"
        let ma = String(format: "%.0f", HR.getMaxHR()!) + " BPM"

        avg.text = av
        min.text = mi
        max.text = ma
        insights.text = HR.getInsights()
        
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
