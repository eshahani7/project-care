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
    @IBOutlet var timePicker: WKInterfacePicker!
    @IBAction func timePickerDidChange(_ value: Int) {
        
    }
    
    @IBOutlet var intensityPicker: WKInterfacePicker!
    @IBAction func intensityPickerDidChange(_ value: Int) {
   
    }
    

    
 
    
    var times: [(String, String)] = [
        ("Item 1", "10"),
        ("Item 2", "20"),
        ("Item 3", "30"),
        ("Item 4", "40"),
        ("Item 5", "50"),
        ("Item 6", "60")
    ]
    var intensities: [(String, String)] = [
        ("Item 1", "LOW"),
        ("Item 2", "MEDIUM"),
        ("Item 3", "HIGH"),
    ]
   
    @IBAction func nextButton() {
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        let timePickerItems: [WKPickerItem] = times.map {
            let pickerItem = WKPickerItem()
            pickerItem.caption = $0.0
            pickerItem.title = $0.1
            return pickerItem
        }
        timePicker.setItems(timePickerItems)
        
//        let intensityPickerItems: [WKPickerItem] = intensities.map {
//            let pickerItem = WKPickerItem()
//            pickerItem.caption = $0.0
//            pickerItem.title = $0.1
//            return pickerItem
//        }
//        intensityPicker.setItems(intensityPickerItems)
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
