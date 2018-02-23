//
//  ViewController.swift
//  projectCARE
//
//  Created by Ekta Shahani on 2/1/18.
//  Copyright © 2018 Ekta Shahani. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

class ViewController: UIViewController {

    let store:HealthStore = HealthStore.getInstance()
    
    
    @IBAction func SleepAnalysis(_ sender: UIButton) {
        performSegue(withIdentifier: "SleepAnalysis", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var barsData = [(title: String, min: Int, max: Int)]()
        var i = 0
        let width = view.bounds.size.width
        let height = view.bounds.size.height
        var chart = generateCharts.createStepsChart(barsData: barsData, width: width, height: height)
        let group = DispatchGroup()
        group.enter()
        store.retrieveStepCount() { steps in
            for step in steps {
                i = i + 1
                barsData.append((title: String(i), min: 0, max: Int(step)))
            }
            chart = generateCharts.createStepsChart(barsData: barsData, width: width, height: height/1.6)
            group.leave()
        }
        group.wait()
        view.addSubview(chart.view)
        store.getExerciseTime() { activeTime in
            print ("Exercise Time")
            for time in activeTime {
                print(time)
            }
        }
        
//        store.getSleepHours(){ hours in
//            print("Sleep Hours")
//            for elm in hours {
//                print(elm)
//            }
//        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // 1
        let nav = self.navigationController?.navigationBar
        
        // 2
        let deepBlue = UIColor(rgb: 0x293044)
        let fontColor = UIColor(rgb: 0xE6E6E6)
        nav?.tintColor = fontColor
        
        // 3
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .scaleAspectFit
        
        // 4
        //let image = UIImage(named: "heart")
        //imageView.image = image
        
        // 5
        navigationItem.titleView = imageView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

