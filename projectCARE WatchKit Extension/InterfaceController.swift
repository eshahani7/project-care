//
//  InterfaceController.swift
//  projectCARE WatchKit Extension
//
//  Created by Ekta Shahani on 2/1/18.
//  Copyright © 2018 Ekta Shahani. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    //MARK: Properties
    //@IBOutlet var timePicker: WKInterfacePicker!
   // @IBAction func timePickerDidChange(_ value: Int) {
        
 //   }

    @IBOutlet var timePicker: WKInterfacePicker!
    
    var times: [(String, String)] = [
        ("Item 1", "10"),
        ("Item 2", "20"),
        ("Item 3", "30"),
        ("Item 4", "40"),
        ("Item 5", "50"),
        ("Item 6", "60")
    ]
    
    struct MyVariables {
        static var timePickerValue = 0
    }

    override func contextForSegue(withIdentifier segueIdentifier: String) -> Any? {
        if segueIdentifier == "timeNext" {
            print("<*> Time selected: \(MyVariables.timePickerValue)")
            return MyVariables.timePickerValue
        }
        else {
            return ""
        }
    }
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        print("<*> Ready")
        // Configure interface objects here.
        
//        let item1 = WKPickerItem()
//        item1.title = "10"
//
//        let item2 = WKPickerItem()
//        item2.title = "20"
//
//        let item3 = WKPickerItem()
//        item3.title = "30"
//
//        let itemsArray = [item1, item2, item3]
//        timePicker.setItems(itemsArray)
        
        let timePickerItems: [WKPickerItem] = times.map {
            let timePickerItem = WKPickerItem()
            timePickerItem.caption = $0.0
            timePickerItem.title = $0.1
            return timePickerItem
        }
        timePicker.setItems(timePickerItems)
        print("<*> Ready to select time.")
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func pickerChanged(_ value: Int) {
        //print(value)
        MyVariables.timePickerValue = value
    }
    
}
