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
    var chtChart = BarChartView(frame: CGRect(x: 40, y: 120, width: 300, height: 300))
    
    var numbers : [Int] = []
    
    @IBAction func SleepAnalysis(_ sender: UIButton) {
        performSegue(withIdentifier: "SleepAnalysis", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        numbers.append(2)
//        numbers.append(4)
//        numbers.append(6)
//        var barsData = [(title: String, min: Int, max: Int)]()
//        let width = view.bounds.size.width
//        let height = view.bounds.size.height
//        var chart = generateCharts.createStepsChart(barsData: barsData, width: width, height: height)
        let group = DispatchGroup()
        group.enter()
        store.retrieveStepCount() { steps in
            for step in steps {
                self.numbers.append(Int(step.steps))
//                barsData.append((title: step.date, min: 0, max: Int(step.steps)))
            }
            group.leave()
        }
        group.wait()
        updateGraph()
        view.addSubview(chtChart)
//            chart = generateCharts.createStepsChart(barsData: barsData, width: width/1.1, height: height/3.8)
//
//            group.leave()
//        }
//        group.wait()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func updateGraph() {
        var barChartEntry = [BarChartDataEntry]()
        for i in 0..<numbers.count {
            let value = BarChartDataEntry(x: Double(i), y: Double(numbers[i]))
            barChartEntry.append(value)
        }
        print(numbers)
        let barChartDataSet = BarChartDataSet(values: barChartEntry, label: "Step count")
        print(barChartDataSet)
        let data = BarChartData(dataSet: barChartDataSet)
        chtChart.data = data
        chtChart.chartDescription?.text = "Step counts vs Time"
        chtChart.setScaleMinima(1, scaleY: 1000)
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

