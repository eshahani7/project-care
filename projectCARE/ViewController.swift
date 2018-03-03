//
//  ViewController.swift
//  projectCARE
//
//  Created by Ekta Shahani on 2/1/18.
//  Copyright © 2018 Ekta Shahani. All rights reserved.
//

import UIKit
import Charts

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
//    var chart: Chart?
//    @IBOutlet weak var chtChart: BarChartView!
    var chtChart = BarChartView(frame: CGRect(x: 15, y: 200, width: 350, height: 350))
    
    var barsData : [(title: String, stepCount: Int)] = []

    @IBAction func SleepAnalysis(_ sender: UIButton) {
        performSegue(withIdentifier: "SleepAnalysis", sender: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //gradient background
        let layer = CAGradientLayer()
        layer.frame = CGRect(x: 0, y: -20, width: 500, height: 600)
        layer.colors = [UIColor.black.cgColor, UIColor(red: 0.2196, green: 0.2588, blue: 0.3882, alpha: 1.0)]
        view.layer.addSublayer(layer)
        
        //STEP label
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 25))
        label.center = CGPoint(x: 200, y: 180)
        label.textAlignment = .center
        label.text = "Steps for last 7 days "
        label.font = UIFont(name:"Helvetica", size: 15.0)
        label.textColor = UIColor(red: 0.8902, green: 0.902, blue: 0.9137, alpha: 0.75)
        self.view.addSubview(label)
        
        //step count chart
        let group = DispatchGroup()
        group.enter()
        store.retrieveStepCount() { steps in
            for step in steps {
                self.barsData.append((title: step.date, stepCount: Int(step.steps)))
            }
            group.leave()
        }
        group.wait()
        generateCharts.updateStepsGraph(stepsData: barsData, chtChart: chtChart)
        view.addSubview(chtChart)
       
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
        
        nav?.topItem?.title = "CARE";
        //nav?.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.red, NSAttributedStringKey.font: UIFont(name: "mplus-1c-regular", size: 21)!]

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

