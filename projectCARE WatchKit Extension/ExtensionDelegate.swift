//
//  ExtensionDelegate.swift
//  projectCARE WatchKit Extension
//
//  Created by Ekta Shahani on 2/1/18.
//  Copyright © 2018 Ekta Shahani. All rights reserved.
//

import WatchKit
import UserNotifications
import HealthKit

class ExtensionDelegate: NSObject, WKExtensionDelegate, UNUserNotificationCenterDelegate
 {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Update the app interface directly.
        print("In here")
        // Play a sound.
        completionHandler(UNNotificationPresentationOptions.alert)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("Goes in here")
        
        
        completionHandler()
        // Else handle actions for other notification types. . .
    }


    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
        print("Watch app started.")
        
        //let center = UNUserNotificationCenter.current()
        UNUserNotificationCenter.current().delegate = self
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (granted, error) in
            if (error != nil){
                print("There was an error \(error.debugDescription)")
            }
            else if granted {
                print("Notifications Authorized!")
            }
        }
        
        let generalCategory = UNNotificationCategory(identifier: "GENERAL",
                                                     actions: [],
                                                     intentIdentifiers: [],
                                                     options: .customDismissAction)
        
        
        // Register the category.
        UNUserNotificationCenter.current().setNotificationCategories([generalCategory])
        
        //set up session
        //let manager:WatchSessionManager = WatchSessionManager()
    }
    
    func sendNotification(title: String, message: String) {
        print("Going to send notification")
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: title, arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: message, arguments: nil)
        content.sound = UNNotificationSound.default()
        // Deliver the notification in five seconds.
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "oneSecond", content: content, trigger: trigger) // Schedule the notification.
        //let center = UNUserNotificationCenter.current()
        UNUserNotificationCenter.current().add(request) { (error : Error?) in
            if let theError = error {
                // Handle any errors
                print("There was a notification error: \(theError.localizedDescription)")
            }
            else{
                print("Successfully added notification.")
            }
        }
    }

    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }

    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        // Sent when the system needs to launch the application in the background to process tasks. Tasks arrive in a set, so loop through and process each one.
        for task in backgroundTasks {
            // Use a switch statement to check the task type
            switch task {
            case let backgroundTask as WKApplicationRefreshBackgroundTask:
                // Be sure to complete the background task once you’re done.
                backgroundTask.setTaskCompleted()
            case let snapshotTask as WKSnapshotRefreshBackgroundTask:
                // Snapshot tasks have a unique completion call, make sure to set your expiration date
                snapshotTask.setTaskCompleted(restoredDefaultState: true, estimatedSnapshotExpiration: Date.distantFuture, userInfo: nil)
            case let connectivityTask as WKWatchConnectivityRefreshBackgroundTask:
                // Be sure to complete the connectivity task once you’re done.
                connectivityTask.setTaskCompleted()
            case let urlSessionTask as WKURLSessionRefreshBackgroundTask:
                // Be sure to complete the URL session task once you’re done.
                urlSessionTask.setTaskCompleted()
            default:
                // make sure to complete unhandled task types
                task.setTaskCompleted()
            }
        }
    }

}


/***************************************************************
//
//  ExtensionDelegate.swift
//  projectCARE WatchKit Extension
//
//  Created by Ekta Shahani on 2/1/18.
//  Copyright © 2018 Ekta Shahani. All rights reserved.
//

import WatchKit
import UserNotifications
import HealthKit

class ExtensionDelegate: NSObject, WKExtensionDelegate {
    
    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
        print("Watch app started.")
        
        let center = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        center.requestAuthorization(options: options) { (granted, error) in
            if (error != nil){
                print("There was an error \(error.debugDescription)")
            }
            else if granted {
                print("Notifications Authorized!")
            }
        }
        
        let generalCategory = UNNotificationCategory(identifier: "GENERAL",
                                                     actions: [],
                                                     intentIdentifiers: [],
                                                     options: .customDismissAction)
        
        
        // Register the category.
        center.setNotificationCategories([generalCategory])
        
        //set up session
        //let manager:WatchSessionManager = WatchSessionManager()
    }
    
    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }
    
    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        // Sent when the system needs to launch the application in the background to process tasks. Tasks arrive in a set, so loop through and process each one.
        for task in backgroundTasks {
            // Use a switch statement to check the task type
            switch task {
            case let backgroundTask as WKApplicationRefreshBackgroundTask:
                // Be sure to complete the background task once you’re done.
                backgroundTask.setTaskCompleted()
            case let snapshotTask as WKSnapshotRefreshBackgroundTask:
                // Snapshot tasks have a unique completion call, make sure to set your expiration date
                snapshotTask.setTaskCompleted(restoredDefaultState: true, estimatedSnapshotExpiration: Date.distantFuture, userInfo: nil)
            case let connectivityTask as WKWatchConnectivityRefreshBackgroundTask:
                // Be sure to complete the connectivity task once you’re done.
                connectivityTask.setTaskCompleted()
            case let urlSessionTask as WKURLSessionRefreshBackgroundTask:
                // Be sure to complete the URL session task once you’re done.
                urlSessionTask.setTaskCompleted()
            default:
                // make sure to complete unhandled task types
                task.setTaskCompleted()
            }
        }
    }
    
}

*********************************************************/

//
//  WatchSessionManager.swift
//  projectCARE
//
//  Created by Aditya Nadkarni on 2/5/18.
//  Copyright © 2018 Ekta Shahani. All rights reserved.
//

//import Foundation
//
//import WatchKit
//import WatchConnectivity
//
//class WatchSessionManager: NSObject, WCSessionDelegate {
//
//    static let sharedManager = WatchSessionManager()
//    fileprivate let session: WCSession? = WCSession.isSupported() ? WCSession.default() : nil
//    fileprivate var validSession: WCSession? {
//        // paired - the user has to have their device paired to the watch
//        // watchAppInstalled - the user must have your watch app installed
//
//        // Note: if the device is paired, but your watch app is not installed
//        // consider prompting the user to install it for a better experience
//        if let session = session, session.isPaired && session.isWatchAppInstalled {
//            return session
//        }
//        return nil
//    }
//
//    private override init() {
//        super.init()
//    }
//
//    func startSession() {
//        session?.delegate = self
//        session?.activate()
//    }
//
//    /**
//     * Called when the session has completed activation.
//     * If session state is WCSessionActivationStateNotActivated there will be an error with more details.
//     */
//    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
//
//    }
//
//    /**
//     * Called when the session can no longer be used to modify or add any new transfers and,
//     * all interactive messages will be cancelled, but delegate callbacks for background transfers can still occur.
//     * This will happen when the selected watch is being changed.
//     */
//    func sessionDidBecomeInactive(_ session: WCSession) {
//
//    }
//    /**
//     * Called when all delegate callbacks for the previously selected watch has occurred.
//     * The session can be re-activated for the now selected watch using activateSession.
//     */
//    func sessionDidDeactivate(_ session: WCSession) {
//
//    }
//}
//
//// MARK: Application Context
//// use when your app needs only the latest information
//// if the data was not sent, it will be replaced
//extension WatchSessionManager {
//
//    // Sender
//    func updateApplicationContext(applicationContext: [String : AnyObject]) throws {
//        if let session = validSession {
//            do {
//                try session.updateApplicationContext(applicationContext)
//            } catch let error {
//                throw error
//            }
//        }
//    }
//
//    // Receiver
//    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
//        // handle receiving application context
//        DispatchQueue.main.async() {
//            // make sure to put on the main queue to update UI!
//        }
//    }
//}
//
//// MARK: User Info
//// use when your app needs all the data
//// FIFO queue
//extension WatchSessionManager {
//
//    // Sender
//    func transferUserInfo(userInfo: [String : AnyObject]) -> WCSessionUserInfoTransfer? {
//        return validSession?.transferUserInfo(userInfo)
//    }
//
//    func session(session: WCSession, didFinishUserInfoTransfer userInfoTransfer: WCSessionUserInfoTransfer, error: Error?) {
//        // implement this on the sender if you need to confirm that
//        // the user info did in fact transfer
//    }
//
//    // Receiver
//    func session(session: WCSession, didReceiveUserInfo userInfo: [String : AnyObject]) {
//        // handle receiving user info
//        DispatchQueue.main.async() {
//            // make sure to put on the main queue to update UI!
//        }
//    }
//
//}
//
//// MARK: Transfer File
//extension WatchSessionManager {
//
//    // Sender
//    func transferFile(file: NSURL, metadata: [String : AnyObject]) -> WCSessionFileTransfer? {
//        return validSession?.transferFile(file as URL, metadata: metadata)
//    }
//
//    func session(session: WCSession, didFinishFileTransfer fileTransfer: WCSessionFileTransfer, error: Error?) {
//        // handle filed transfer completion
//    }
//
//    // Receiver
//    func session(session: WCSession, didReceiveFile file: WCSessionFile) {
//        // handle receiving file
//        DispatchQueue.main.async() {
//            // make sure to put on the main queue to update UI!
//        }
//    }
//}
//
//
//// MARK: Interactive Messaging
//extension WatchSessionManager {
//
//    // Live messaging! App has to be reachable
//    private var validReachableSession: WCSession? {
//        if let session = validSession, session.isReachable {
//            return session
//        }
//        return nil
//    }
//
//    // Sender
//    func sendMessage(message: [String : AnyObject], replyHandler: (([String : Any]) -> Void)? = nil, errorHandler: ((Error) -> Void)? = nil) {
//        validReachableSession?.sendMessage(message, replyHandler: replyHandler, errorHandler: errorHandler)
//    }
//
//    func sendMessageData(data: Data, replyHandler: ((Data) -> Void)? = nil, errorHandler: ((Error) -> Void)? = nil) {
//        validReachableSession?.sendMessageData(data, replyHandler: replyHandler, errorHandler: errorHandler)
//    }
//
//    // Receiver
//    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
//        // handle receiving message
//        DispatchQueue.main.async() {
//            // make sure to put on the main queue to update UI!
//        }
//    }
//
//    func session(session: WCSession, didReceiveMessageData messageData: NSData, replyHandler: (NSData) -> Void) {
//        // handle receiving message data
//        DispatchQueue.main.async() {
//            // make sure to put on the main queue to update UI!
//        }
//    }
//}
//

