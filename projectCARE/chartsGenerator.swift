//
//  chartsGenerator.swift
//  projectCARE
//
//  Created by admin on 2/21/18.
//  Copyright © 2018 Ekta Shahani. All rights reserved.
//
import Foundation
import UIKit
import Charts

class generateCharts {
    
    public static func updateStepsGraph(numbers: [Int], chtChart: BarChartView) {
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
        chtChart.setScaleMinima(1, scaleY: 1)
    }

    public static func updateSleepActivityGraph(data: [(title: String, graph: [Double])], chart: BarChartView) {
        var barChartEntry = [BarChartDataEntry]()
        for i in 0..<data.count {
            let value = BarChartDataEntry(x: Double(i), y: Double(data[i].graph[0]))
            barChartEntry.append(value)
        }
        print(data)
        let barChartDataSet = BarChartDataSet(values: barChartEntry, label: "Sleep Hours")
        print(barChartDataSet)
        let data = BarChartData(dataSet: barChartDataSet)
        chart.data = data
        chart.chartDescription?.text = "Sleeo Hours vs Activity"
        chart.setScaleMinima(1, scaleY: 1)
    }
}

