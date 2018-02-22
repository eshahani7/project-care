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


class StartWorkoutInterfaceController: WKInterfaceController, HKWorkoutSessionDelegate {
   
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
    var currenQuery : HKQuery?
    
    var startDate:Date = Date()
    var endDate:Date = Date()
    
    var time:Double = 0
    var intensity:Int = 1
    
    var workoutUtilities:WorkoutUtilities?
    
    //MARK: ACTIONS
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        //         Configure interface objects here.
        let dict = context as? NSDictionary
        if dict != nil {
            time = Double (10*(dict!["time"] as! Int)) + 10
            intensity = (dict!["intensity"] as! Int) + 1
        }
        
        print ("Time: \(time)")
        print ("Intensity: \(intensity)")
    }
    
    @IBAction func StartEndAction() {
        if (self.workoutActive) {
            //finish the current workout
            self.workoutActive = false
            WorkoutTimer.stop()
            self.StartEndButton.setTitle("Start")
            if let workout = self.session {
                endWorkout();
                healthStore.end(workout)
            }
        } else {
            //start a new workout
            self.workoutActive = true
            wkTimerReset(timer: WorkoutTimer, interval: 0.0)
            self.StartEndButton.setTitle("Stop")
            workoutUtilities = WorkoutUtilities(workoutMins: time, intensityLevel: intensity)
            startWorkout()
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
        HeartRateLabel.setText("not allowed")
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        switch toState {
        case .running:
            workoutDidStart(date)
        case .ended:
            workoutDidEnd(date)
        default:
            print("Unexpected state \(toState)")
        }
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        // Do nothing for now
        print("Workout error")
    }
    
    
    func workoutDidStart(_ date : Date) {
        if let query = createHeartRateStreamingQuery(date) {
            self.currenQuery = query
            healthStore.execute(query)
        } else {
            HeartRateLabel.setText("cannot start")
        }
    }
    
    func workoutDidEnd(_ date : Date) {
        healthStore.stop(self.currenQuery!)
        HeartRateLabel.setText("Heart Rate: ---")
        session = nil
    }
    
    func startWorkout() {
        // If we have already started the workout, then do nothing.
        if (session != nil) {
            return
        }
        
        startDate = Date()
        
        // Configure the workout session.
        let workoutConfiguration = HKWorkoutConfiguration()
        workoutConfiguration.activityType = .crossTraining
        workoutConfiguration.locationType = .indoor
        
        do {
            session = try HKWorkoutSession(configuration: workoutConfiguration)
            session?.delegate = self
        } catch {
            fatalError("Unable to create the workout session!")
        }
        
        healthStore.start(self.session!)
    }
    
    var heartRateIntervalSamples = [HKQuantitySample]();
    
    func endWorkout() {
        endDate = Date()
        
        guard let activeEnergyType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned) else {
            fatalError("*** Unable to create the active energy burned type ***")
        }
        
        let device = HKDevice.local()
        
        let datePredicate = HKQuery.predicateForSamples(withStart: session?.startDate, end: session?.endDate)
        let devicePredicate = HKQuery.predicateForObjects(from: [device])
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates:[datePredicate, devicePredicate])
        
        let sortByDate = NSSortDescriptor(key:HKSampleSortIdentifierStartDate , ascending: true)
        
        let healthStore = self.healthStore
        
        let query = HKSampleQuery(sampleType: activeEnergyType, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: [sortByDate]) { (query, returnedSamples, error) -> Void in
            
            guard var samples = returnedSamples as? [HKQuantitySample] else {
                // Add proper error handling here...
                print("*** an error occurred: \(String(describing: error?.localizedDescription)) ***")
                return
            }
            
            // create the workout here
            let energyUnit = HKUnit.kilocalorie()
            var totalActiveEnergy : Double = 0.0
            
            for sample in samples {
                totalActiveEnergy += sample.quantity.doubleValue(for: energyUnit)
            }
            
            //            let startDate = self.session?.startDate ?? NSDate() as Date
            //            let endDate = self.session?.endDate ?? NSDate() as Date
            
            var duration: TimeInterval {
                return (self.endDate.timeIntervalSince((self.startDate)))
            }
            
            print ("Duration: \(duration)")
            
            let totalActiveEnergyQuantity = HKQuantity(unit: energyUnit, doubleValue: totalActiveEnergy)
            
            let workout = HKWorkout(activityType: HKWorkoutActivityType.running,
                                    start: self.startDate,
                                    end: self.endDate,
                                    duration: duration,
                                    totalEnergyBurned: totalActiveEnergyQuantity,
                                    totalDistance: nil,
                                    device: HKDevice.local(),
                                    metadata: [HKMetadataKeyIndoorWorkout : true])
            
            guard healthStore.authorizationStatus(for: HKObjectType.workoutType()) == .sharingAuthorized else {
                print("*** the app does not have permission to save workout samples ***")
                return
            }
            
            healthStore.save(workout, withCompletion: { (success, error) -> Void in
                guard success else {
                    // Add proper error handling here...
                    print("*** an error occurred: \(String(describing: error?.localizedDescription)) ***")
                    self.displayNotAllowed()
                    return
                }
                
                for sample in self.heartRateIntervalSamples {
                    samples.append(sample)
                }
                
                healthStore.add(samples, to: workout, completion: { (success, error) -> Void in
                    guard success else {
                        // Add proper error handling here...
                        print("*** an error occurred: \(String(describing: error?.localizedDescription)) ***")
                        return
                    }
                    
                    // Provide clear feedback that the workout saved successfully here…
                    print("Workout saved!")
                    self.HeartRateLabel.setText("Workout Saved!")
                })
            })
        }
        
        healthStore.execute(query)
    }
    
    func createHeartRateStreamingQuery(_ workoutStartDate: Date) -> HKQuery? {
        
        
        guard let quantityType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate) else { return nil }
        let datePredicate = HKQuery.predicateForSamples(withStart: workoutStartDate, end: nil, options: .strictEndDate )
        //let devicePredicate = HKQuery.predicateForObjects(from: [HKDevice.local()])
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates:[datePredicate])
        
        
        let heartRateQuery = HKAnchoredObjectQuery(type: quantityType, predicate: predicate, anchor: nil, limit: Int(HKObjectQueryNoLimit)) { (query, sampleObjects, deletedObjects, newAnchor, error) -> Void in
            //guard let newAnchor = newAnchor else {return}
            //self.anchor = newAnchor
            self.updateHeartRate(sampleObjects)
        }
        
        heartRateQuery.updateHandler = {(query, samples, deleteObjects, newAnchor, error) -> Void in
            //self.anchor = newAnchor!
            self.updateHeartRate(samples)
        }
        return heartRateQuery
    }
    
    func updateHeartRate(_ samples: [HKSample]?) {
        guard let heartRateSamples = samples as? [HKQuantitySample] else {return}
        
        DispatchQueue.main.async {
            guard let sample = heartRateSamples.first else{return}
            let value = sample.quantity.doubleValue(for: self.heartRateUnit)
            
            let notificationDelegate = ExtensionDelegate()
            
//            let soundURL = URL(fileURLWithPath: "./airHornSound.wav")
            
          
//            let fileAsset:WKAudioFileAsset = WKAudioFileAsset(url: soundURL)
//            let playerItem = WKAudioFilePlayerItem(asset: fileAsset)
//            let audioPlayer = WKAudioFilePlayer(playerItem: playerItem)
//
//            if(audioPlayer.status == WKAudioFilePlayerStatus.readyToPlay){
//                audioPlayer.play()
//                print("Sound played!")
//            }
            
            if (self.workoutUtilities?.isTooFast(currHR: value))!{
                print ("Going too fast!!!")
                self.paceLabel.setText("GOING TOO FAST!")
                //notificationDelegate.sendNotification(title: "GOING TOO FAST!", message: "going fast boi")
            }
            else if (self.workoutUtilities?.isTooSlow(currHR: value))!{
                print ("Going too SLOW.")
                self.paceLabel.setText("GOING TOO SLOW!")
                //notificationDelegate.sendNotification(title: "GOING TOO SLOW!", message: "going slow boi")
            }
            else {
                print ("Going at a good pace!")
            }
            
            let heartRateForIntervalSample = sample
            self.heartRateIntervalSamples.append(heartRateForIntervalSample)
            print("Added heart rate sample. \(heartRateForIntervalSample.quantity.doubleValue(for: self.heartRateUnit))")
            
            self.HeartRateLabel.setText("Heart Rate: " + String(UInt16(value)))
            
            // retrieve source from sample
            //            let name = sample.sourceRevision.source.name
            //            self.updateDeviceName(name)
        }
        
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}

/******************************************************************

//
//  InterfaceController.swift
//  projectCARE WatchKit Extension
//
//  Created by Ekta Shahani on 2/1/18.
//  Copyright © 2018 Ekta Shahani. All rights reserved.
//
import WatchKit
import HealthKit
import Foundation
import UserNotifications

class InterfaceController: WKInterfaceController, HKWorkoutSessionDelegate {
    
    //MARK: Properties
    @IBOutlet var sessionButton: WKInterfaceButton!
    
    @IBOutlet var titleLabel: WKInterfaceLabel!
    
    @IBOutlet var label: WKInterfaceLabel!
    let store:HealthStore = HealthStore.getInstance()
    
    let healthStore = HKHealthStore()
    
    //State of the app - is the workout activated
    var workoutActive = false
    
    // define the activity type and location
    var session : HKWorkoutSession?
    let heartRateUnit = HKUnit(from: "count/min")
    //var anchor = HKQueryAnchor(fromValue: Int(HKAnchoredObjectQueryNoAnchor))
    var currenQuery : HKQuery?
    
    var startDate:Date = Date()
    var endDate:Date = Date()
    
    var workoutUtilities:WorkoutUtilities?
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        guard HKHealthStore.isHealthDataAvailable() == true else {
            sessionButton.setTitle("not available")
            return
        }
        
        guard HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate) != nil else {
            displayNotAllowed()
            return
        }
    }
    
    func displayNotAllowed() {
        label.setText("not allowed")
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        switch toState {
        case .running:
            workoutDidStart(date)
        case .ended:
            workoutDidEnd(date)
        default:
            print("Unexpected state \(toState)")
        }
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        // Do nothing for now
        print("Workout error")
    }
    
    
    func workoutDidStart(_ date : Date) {
        if let query = createHeartRateStreamingQuery(date) {
            self.currenQuery = query
            healthStore.execute(query)
        } else {
            label.setText("cannot start")
        }
    }
    
    func workoutDidEnd(_ date : Date) {
        healthStore.stop(self.currenQuery!)
        label.setText("---")
        session = nil
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    //MARK: Actions
    @IBAction func sessionButtonPressed() {
        if (self.workoutActive) {
            //finish the current workout
            self.workoutActive = false
            self.sessionButton.setTitle("Start")
            if let workout = self.session {
                endWorkout();
                healthStore.end(workout)
            }
        } else {
            //start a new workout
            self.workoutActive = true
            self.sessionButton.setTitle("Stop")
            workoutUtilities = WorkoutUtilities(workoutMins: 10.0, intensityLevel: 3)
            startWorkout()
        }
        //        print("Button pressed!")
        //        let configuration = HKWorkoutConfiguration()
        //        configuration.activityType = .running
        //        configuration.locationType = .indoor
        //
        //        do {
        //
        //            let session = try HKWorkoutSession(configuration: configuration)
        //
        //            session.delegate = self as? HKWorkoutSessionDelegate
        //            healthStore.start(session)
        //            print("Session ended!")
        //
        //            store.startObservingForStepCountSamples()
        //        }
        //        catch let error as NSError {
        //            // Perform proper error handling here...
        //            fatalError("*** Unable to create the workout session: \(error.localizedDescription) ***")
        //        }
    }
    
    func startWorkout() {
        // If we have already started the workout, then do nothing.
        if (session != nil) {
            return
        }
        
        startDate = Date()
        
        // Configure the workout session.
        let workoutConfiguration = HKWorkoutConfiguration()
        workoutConfiguration.activityType = .crossTraining
        workoutConfiguration.locationType = .indoor
        
        do {
            session = try HKWorkoutSession(configuration: workoutConfiguration)
            session?.delegate = self
        } catch {
            fatalError("Unable to create the workout session!")
        }
        
        healthStore.start(self.session!)
    }
    
    var heartRateIntervalSamples = [HKQuantitySample]();
    
    func endWorkout() {
        endDate = Date()
        
        guard let activeEnergyType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned) else {
            fatalError("*** Unable to create the active energy burned type ***")
        }
        
        let device = HKDevice.local()
        
        let datePredicate = HKQuery.predicateForSamples(withStart: session?.startDate, end: session?.endDate)
        let devicePredicate = HKQuery.predicateForObjects(from: [device])
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates:[datePredicate, devicePredicate])
        
        let sortByDate = NSSortDescriptor(key:HKSampleSortIdentifierStartDate , ascending: true)
        
        let healthStore = self.healthStore
        
        let query = HKSampleQuery(sampleType: activeEnergyType, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: [sortByDate]) { (query, returnedSamples, error) -> Void in
            
            guard var samples = returnedSamples as? [HKQuantitySample] else {
                // Add proper error handling here...
                print("*** an error occurred: \(String(describing: error?.localizedDescription)) ***")
                return
            }
            
            // create the workout here
            let energyUnit = HKUnit.kilocalorie()
            var totalActiveEnergy : Double = 0.0
            
            for sample in samples {
                totalActiveEnergy += sample.quantity.doubleValue(for: energyUnit)
            }
            
            //            let startDate = self.session?.startDate ?? NSDate() as Date
            //            let endDate = self.session?.endDate ?? NSDate() as Date
            
            var duration: TimeInterval {
                return (self.endDate.timeIntervalSince((self.startDate)))
            }
            
            print ("Duration: \(duration)")
            
            let totalActiveEnergyQuantity = HKQuantity(unit: energyUnit, doubleValue: totalActiveEnergy)
            
            let workout = HKWorkout(activityType: HKWorkoutActivityType.running,
                                    start: self.startDate,
                                    end: self.endDate,
                                    duration: duration,
                                    totalEnergyBurned: totalActiveEnergyQuantity,
                                    totalDistance: nil,
                                    device: HKDevice.local(),
                                    metadata: [HKMetadataKeyIndoorWorkout : true])
            
            guard healthStore.authorizationStatus(for: HKObjectType.workoutType()) == .sharingAuthorized else {
                print("*** the app does not have permission to save workout samples ***")
                return
            }
            
            healthStore.save(workout, withCompletion: { (success, error) -> Void in
                guard success else {
                    // Add proper error handling here...
                    print("*** an error occurred: \(String(describing: error?.localizedDescription)) ***")
                    self.displayNotAllowed()
                    return
                }
                
                for sample in self.heartRateIntervalSamples {
                    print("Sample Type: \(sample.quantityType)")
                    samples.append(sample)
                    print("Added to workout: \(sample.quantity.doubleValue(for: self.heartRateUnit))")
                }
                
                healthStore.add(samples, to: workout, completion: { (success, error) -> Void in
                    guard success else {
                        // Add proper error handling here...
                        print("*** an error occurred: \(String(describing: error?.localizedDescription)) ***")
                        return
                    }
                    
                    // Provide clear feedback that the workout saved successfully here…
                    print("Workout saved!")
                    self.label.setText("Workout Saved!")
                })
            })
        }
        
        healthStore.execute(query)
    }
    
    func createHeartRateStreamingQuery(_ workoutStartDate: Date) -> HKQuery? {
        
        
        guard let quantityType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate) else { return nil }
        let datePredicate = HKQuery.predicateForSamples(withStart: workoutStartDate, end: nil, options: .strictEndDate )
        //let devicePredicate = HKQuery.predicateForObjects(from: [HKDevice.local()])
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates:[datePredicate])
        
        
        let heartRateQuery = HKAnchoredObjectQuery(type: quantityType, predicate: predicate, anchor: nil, limit: Int(HKObjectQueryNoLimit)) { (query, sampleObjects, deletedObjects, newAnchor, error) -> Void in
            //guard let newAnchor = newAnchor else {return}
            //self.anchor = newAnchor
            self.updateHeartRate(sampleObjects)
        }
        
        heartRateQuery.updateHandler = {(query, samples, deleteObjects, newAnchor, error) -> Void in
            //self.anchor = newAnchor!
            self.updateHeartRate(samples)
        }
        return heartRateQuery
    }
    
    func updateHeartRate(_ samples: [HKSample]?) {
        guard let heartRateSamples = samples as? [HKQuantitySample] else {return}
        
        DispatchQueue.main.async {
            guard let sample = heartRateSamples.first else{return}
            let value = sample.quantity.doubleValue(for: self.heartRateUnit)
            
            let content = UNMutableNotificationContent()
            content.title = NSString.localizedUserNotificationString(forKey: "GOING TOO SLOW!", arguments: nil)
            content.body = NSString.localizedUserNotificationString(forKey: "Hello_message_body", arguments: nil)
            content.sound = UNNotificationSound.default()
            // Deliver the notification in five seconds.
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let request = UNNotificationRequest(identifier: "FiveSecond", content: content, trigger: trigger) // Schedule the notification.
            let center = UNUserNotificationCenter.current()
            center.add(request) { (error : Error?) in
                if let theError = error {
                    // Handle any errors
                }
            }
            
            
            //self.sendNotification(title: "NOTIFICATION", message: "testing")
            
            if (self.workoutUtilities?.isTooFast(currHR: value))!{
                print ("Going too fast!!!")
                //self.sendNotification(title: "GOING TOO FAST!", message: "Slow down!")
            }
            else if (self.workoutUtilities?.isTooSlow(currHR: value))!{
                print ("Going too SLOW.")
                //self.sendNotification(title: "GOING TOO SLOW!", message: "Go faster!")
            }
            else {
                print ("Going at a good pace!")
            }
            
            let heartRateForIntervalSample = sample
            self.heartRateIntervalSamples.append(heartRateForIntervalSample)
            print("Added heart rate sample. \(heartRateForIntervalSample.quantity.doubleValue(for: self.heartRateUnit))")
            
            self.label.setText(String(UInt16(value)))
            
            // retrieve source from sample
            //            let name = sample.sourceRevision.source.name
            //            self.updateDeviceName(name)
        }
        
    }
    
    func sendNotification(title: String, message: String) {
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: title, arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: message, arguments: nil)
        content.sound = UNNotificationSound.default()
        // Deliver the notification in five seconds.
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "oneSecond", content: content, trigger: trigger) // Schedule the notification.
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error : Error?) in
            if let theError = error {
                // Handle any errors
                print("There was a notification error: \(theError.localizedDescription)")
            }
        }
    }
    
}

********************************************************/