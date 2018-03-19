//
//  StartWorkoutInterfaceController.swift
//  projectCARE WatchKit Extension
//
//  Created by Cindy Lu on 2/19/18.
//  Copyright © 2018 Ekta Shahani. All rights reserved.
//
import WatchKit
import HealthKit
import Foundation
import UserNotifications


class StartWorkoutInterfaceController: WKInterfaceController {
    
    //MARK: PROPERTIES
    
    let store:HealthStore = HealthStore.getInstance()
    
    @IBOutlet var HeartRateLabel: WKInterfaceLabel!
    
    @IBOutlet var WorkoutTimer: WKInterfaceTimer!
    
    @IBOutlet var paceLabel: WKInterfaceLabel!
    
    var isStarted = false
    @IBOutlet var StartEndButton: WKInterfaceButton!
    
    let healthStore = HKHealthStore()
    
    //State of the app - is the workout activated
    var workoutActive = false
    
    // define the activity type and location
    var session : HKWorkoutSession?
    let heartRateUnit = HKUnit(from: "count/min")
    //var anchor = HKQueryAnchor(fromValue: Int(HKAnchoredObjectQueryNoAnchor))
    var currenQuery : HKAnchoredObjectQuery?
    
    var startDate:Date = Date()
    var endDate:Date = Date()
    
    var time:Double = 0
    var intensity:Int = 1
    
    var workoutUtilities:WorkoutUtilities?
    var workoutSession:WorkoutSession = WorkoutSession()
    
    //initialize audio player to play air horn sound
    //let audioPlayer = WKAudioFilePlayer(playerItem: WKAudioFilePlayerItem(asset: WKAudioFileAsset(url: URL(fileURLWithPath: "./airHornSound.wav"))))
    
    //MARK: ACTIONS
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        //         Configure interface objects here.
        let dict = context as? NSDictionary
        if dict != nil {
            time = Double (10*(dict!["time"] as! Int)) + 10
            intensity = (dict!["intensity"] as! Int) + 1
        }
        
        print ("<*> Time passed in: \(time)")
        print ("<*> Intensity passed in: \(intensity)")
    }
    
    @IBAction func StartEndAction() {
        if (workoutSession.workoutActive) {
            //finish the current workout
            workoutSession.workoutActive = false
            WorkoutTimer.stop()
            self.StartEndButton.setTitle("Start")
            if let workout = workoutSession.session {
                print("<*> Ending workout.")
                healthStore.stop(self.currenQuery!)
                workoutSession.endWorkout(intensity: self.intensity, time: self.time, calorieBurnGoal: self.workoutUtilities?.predictCalorieBurn(), completion: {(success, error) in
                    if let Error = error{
                        print ("<*> There was an error ending workout: \(Error.localizedDescription)")
                        self.displayNotAllowed()
                    }
                    else{
                        self.HeartRateLabel.setText("Workout Saved!")
                        print ("<*> Workout Saved!")
                        self.paceLabel.setText("")
                    }
                })
                healthStore.end(workout)
            }
        } else {
            //start a new workout
            print("<*> Starting workout.")
            workoutSession.workoutActive = true
            wkTimerReset(timer: WorkoutTimer, interval: 0.0)
            startDate = Date()
            
            //Change button
            self.StartEndButton.setTitle("Stop")
            
            //Initialize workout utilities with time and intensity
            workoutUtilities = WorkoutUtilities(workoutMins: time, intensityLevel: intensity)
            
            //Use workoutSession to start a HKWorkoutSession
            workoutSession.startWorkout(completion: {(success) in
                if let Success = success{
                    if(Success){
                        print("<*> Workout started.")
                        self.HeartRateLabel.setText("Workout Started!")
                        if let query:HKAnchoredObjectQuery = self.workoutSession.createHeartRateStreamingQuery(Date()) {
                            query.updateHandler = {(query, samples, deleteObjects, newAnchor, error) -> Void in
                                //self.anchor = newAnchor!
                                self.updateHeartRate(samples)
                            }
                            self.currenQuery = query
                            self.healthStore.execute(query)
                        }
                        
                        
                    }
                    else{
                        print ("<*> Could not start workout.")
                        self.HeartRateLabel.setText("Could not start workout")
                    }
                }
            })
        }
    }
    
    func wkTimerReset(timer:WKInterfaceTimer, interval:TimeInterval) {
        timer.stop()
        let time = NSDate(timeIntervalSinceNow: interval)
        timer.setDate(time as Date)
        timer.start()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        guard HKHealthStore.isHealthDataAvailable() == true else {
            StartEndButton.setTitle("Health data not available")
            return
        }
        
        guard HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate) != nil else {
            displayNotAllowed()
            return
        }
    }
    
    func displayNotAllowed() {
        print("<*> Not allowed.")
        HeartRateLabel.setText("not allowed")
    }
    
    func updateHeartRate(_ samples: [HKSample]?) {
        guard let heartRateSamples = samples as? [HKQuantitySample] else {return}
        
        DispatchQueue.main.async {
            guard let sample = heartRateSamples.first else{return}
            let value = sample.quantity.doubleValue(for: self.heartRateUnit)
            
            let heartRateForIntervalSample = sample
            self.workoutSession.heartRateIntervalSamples.append(heartRateForIntervalSample)
            //print("Added heart rate sample. \(heartRateForIntervalSample.quantity.doubleValue(for: self.heartRateUnit))")
            self.HeartRateLabel.setText("Heart Rate: " + String(UInt16(value)))
            print("<*> Heart Rate: " + String(UInt16(value)))
            
            if (self.workoutUtilities?.isTooFast(currHR: value, startDate: self.startDate))!{
                print ("<*> Going too fast!!!")
                self.paceLabel.setText("GOING TOO FAST!")
            }
            else if (self.workoutUtilities?.isTooSlow(currHR: value, startDate: self.startDate))!{
                print ("<*> Going too SLOW.")
                self.paceLabel.setText("GOING TOO SLOW!")
            }
            else {
                print ("<*> Going at a good pace!")
            }
        }
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
}
