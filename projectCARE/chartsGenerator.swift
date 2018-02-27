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
        chtChart.chartDescription?.textColor = UIColor.white
        chtChart.setScaleMinima(1, scaleY: 1)
        chtChart.xAxis.labelPosition = .bottom
        chtChart.xAxis.labelTextColor = UIColor.white
        chtChart.leftAxis.labelTextColor = UIColor.white
        chtChart.xAxis.drawGridLinesEnabled = false
        chtChart.leftAxis.drawGridLinesEnabled = false
        chtChart.drawValueAboveBarEnabled = false
        chtChart.rightAxis.enabled = false
        chtChart.drawGridBackgroundEnabled = false
    }

    public static func updateSleepActivityGraph(sleepData: [(title: String, graph: [Double])], activityData: [(title: String, graph: [Double])], chart: BarChartView) {
        var barChartSleepEntry = [BarChartDataEntry]()
        for i in 0...sleepData.count - 1 {
            let value = BarChartDataEntry(x: Double(i), y: Double(sleepData[i].graph[0]))
            barChartSleepEntry.append(value)
        }
        var barChartActivityEntry = [BarChartDataEntry]()
        for i in 0...activityData.count - 1 {
            let value = BarChartDataEntry(x: Double(i), y: Double(activityData[i].graph[0]))
            barChartActivityEntry.append(value)
        }
        let barChartActivityDataSet = BarChartDataSet(values: barChartActivityEntry, label: "Active Hours")
        let barChartSleepDataSet = BarChartDataSet(values: barChartSleepEntry, label: "Sleep Hours")
        barChartSleepDataSet.colors = [UIColor.red]
        barChartActivityDataSet.colors = [UIColor.lightGray]
        let data = BarChartData()
        data.addDataSet(barChartSleepDataSet)
        data.addDataSet(barChartActivityDataSet)
        chart.data = data
        chart.chartDescription?.text = ""
        chart.setScaleMinima(1, scaleY: 1)
        chart.xAxis.labelPosition = .bottom
        chart.legend.textColor = UIColor.white
        chart.xAxis.labelTextColor = UIColor.white
        chart.leftAxis.labelTextColor = UIColor.white
        chart.xAxis.drawGridLinesEnabled = false
        chart.leftAxis.drawGridLinesEnabled = false
        chart.drawValueAboveBarEnabled = false
        chart.rightAxis.enabled = false
        chart.drawGridBackgroundEnabled = false
    }
    
    public static func updateHRWorkoutGraph(data: [(heartRate: Double, timeSinceStart:Double)], chart: ScatterChartView) {
        var dataEntry = [ChartDataEntry]()
        for i in 0..<data.count {
            let value1 = ChartDataEntry(x: Double(data[i].timeSinceStart) , y: Double(data[i].heartRate) )
            dataEntry.append(value1)
            print(value1)
        }
        let dataSet = ScatterChartDataSet(values: dataEntry, label: "HeartRate" )
        print(dataSet)
        dataSet.setColor(UIColor.red)
        var workoutHRDataSet = [ScatterChartDataSet]()
        workoutHRDataSet.append(dataSet)
        
        let data = ScatterChartData(dataSets:workoutHRDataSet)
        chart.data = data
        chart.chartDescription?.text = "Heart vs Activity"
        chart.setScaleMinima(1, scaleY: 1)
        chart.rightAxis.enabled=false
        
        print(data)

    }
}

