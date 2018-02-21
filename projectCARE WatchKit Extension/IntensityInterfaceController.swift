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
    @IBOutlet var timeValue: WKInterfaceLabel!
    
    var intensities: [(String, String)] = [
        ("Item 1", "LOW"),
        ("Item 2", "MEDIUM"),
        ("Item 3", "HIGH"),
    ]
    
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
        
        if let val: String = context as? String {
            self.timeValue.setText(val)
        } else {
            self.timeValue.setText("")
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
    @IBAction func pickerChanged(_ value: Int) {
        print(value)
    }
    
}
