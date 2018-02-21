//
//  IntensityInterfaceController.swift
//  projectCARE WatchKit Extension
//
//  Created by Cindy Lu on 2/19/18.
//  Copyright © 2018 Ekta Shahani. All rights reserved.
//

import WatchKit
import Foundation


class IntensityInterfaceController: WKInterfaceController {

    @IBOutlet var intensityPicker: WKInterfacePicker!
    
    var intensities: [(String, String)] = [
        ("Item 1", "LOW"),
        ("Item 2", "MEDIUM"),
        ("Item 3", "HIGH"),
    ]
    
    struct MyVariables {
        static var timePickerValue = 0
        static var intensityPickerValue = 0
    }
    
    override func contextForSegue(withIdentifier segueIdentifier: String) -> Any? {
        if segueIdentifier == "intensityNext" {
            return ["time":  MyVariables.timePickerValue,
                    "intensity": MyVariables.intensityPickerValue]
        }
        else {
            return ""
        }
    }

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        let intensityPickerItems: [WKPickerItem] = intensities.map {
            let intensityPickerItem = WKPickerItem()
            intensityPickerItem.caption = $0.0
            intensityPickerItem.title = $0.1
            return intensityPickerItem
        }
        intensityPicker.setItems(intensityPickerItems)
        
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
        print(value)
        MyVariables.intensityPickerValue = value
    }
    
}
