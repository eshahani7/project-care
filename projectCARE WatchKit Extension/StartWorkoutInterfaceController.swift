//
//  StartWorkoutInterfaceController.swift
//  projectCARE WatchKit Extension
//
//  Created by Cindy Lu on 2/19/18.
//  Copyright © 2018 Ekta Shahani. All rights reserved.
//

import WatchKit
import Foundation


class StartWorkoutInterfaceController: WKInterfaceController {
   
    @IBOutlet var HeartRateLabel: WKInterfaceLabel!
    
    @IBOutlet var WorkoutTimer: WKInterfaceTimer!
    
    var isStarted = false
    @IBOutlet var StartEndButton: WKInterfaceButton!
    @IBAction func StartEndAction() {
        isStarted = !isStarted
        if isStarted {
            StartEndButton.setTitle("END")
            wkTimerReset(timer: WorkoutTimer, interval: 0.0)
        } else {
            WorkoutTimer.stop()
        }
    }
    
    func wkTimerReset(timer:WKInterfaceTimer, interval:TimeInterval) {
        timer.stop()
        let time = NSDate(timeIntervalSinceNow: interval)
        timer.setDate(time as Date)
        timer.start()
    }

    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        var dict = context as? NSDictionary
        if dict != nil {
            var time = dict!["time"] as! String
            var intensity = dict!["intensity"] as! String
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
