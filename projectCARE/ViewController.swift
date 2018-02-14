//
//  ViewController.swift
//  projectCARE
//
//  Created by Ekta Shahani on 2/1/18.
//  Copyright © 2018 Ekta Shahani. All rights reserved.
//

import UIKit
import SwiftCharts

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let chartConfig = BarsChartConfig(
            valsAxisConfig: ChartAxisConfig(from: 0, to: 8, by: 2)
        )

        let frame = CGRect(x: 0, y: 70, width: 300, height: 500)

        let chart = BarsChart(
            frame: frame,
            chartConfig: chartConfig,
            xTitle: "X axis",
            yTitle: "Y axis",
            bars: [
                ("A", 2),
                ("B", 4.5),
                ("C", 3),
                ("D", 5.4),
                ("E", 6.8),
                ("F", 0.5)
            ],
            color: UIColor.red,
            barWidth: 20
        )

        self.view.addSubview(chart.view)
//
//        let chartConfig = ChartConfigXY(
//            xAxisConfig: ChartAxisConfig(from: 2, to: 14, by: 2),
//            yAxisConfig: ChartAxisConfig(from: 0, to: 14, by: 2)
//        )
//
//        let frame = CGRect(x: 0, y: 70, width: 300, height: 500)
//
//        let chart = LineChart(
//            frame: frame,
//            chartConfig: chartConfig,
//            xTitle: "TIME",
//            yTitle: "STEP COUNT",
//            lines: [
//                (chartPoints: [(2.0, 10.6), (4.2, 5.1), (7.3, 3.0), (8.1, 5.5), (14.0, 8.0)], color: UIColor.red),
//                (chartPoints: [(2.0, 2.6), (4.2, 4.1), (7.3, 1.0), (8.1, 11.5), (14.0, 3.0)], color: UIColor.blue)
//            ]
//        )
//
//        self.view.addSubview(chart.view)
        //self.chart = chart
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

