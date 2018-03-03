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
//        print(numbers)
        let barChartDataSet = BarChartDataSet(values: barChartEntry, label: "Step count")
//        print(barChartDataSet)
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
        var barChartActivityEntry = [BarChartDataEntry]()
        var xValues = [String]()
        if(sleepData.count != 0) {
            for i in 0...sleepData.count - 1 {
                xValues.append(getDayOfWeek(date: sleepData[i].title))
                let value = BarChartDataEntry(x: Double(i), y: Double(sleepData[i].graph[0]))
                barChartSleepEntry.append(value)
            }
        } else {
            // throw something here
        }
        if(activityData.count != 0) {
            for i in 0...activityData.count - 1 {
                let value = BarChartDataEntry(x: Double(i), y: Double(activityData[i].graph[0]))
                barChartActivityEntry.append(value)
            }
        } else {
            //throw something here
        }
        let barChartActivityDataSet = BarChartDataSet(values: barChartActivityEntry, label: "Active Hours")
        let barChartSleepDataSet = BarChartDataSet(values: barChartSleepEntry, label: "Sleep Hours")
        
        let chartFormatter = BarChartFormatter(labels: xValues)
        let xAxis = XAxis()
        xAxis.valueFormatter = chartFormatter
        chart.xAxis.valueFormatter = xAxis.valueFormatter
        
        barChartSleepDataSet.colors = [UIColor.red]
        barChartActivityDataSet.colors = [UIColor.lightGray]
        let data = BarChartData()
        data.addDataSet(barChartSleepDataSet)
        data.addDataSet(barChartActivityDataSet)
        chart.data = data

        chart.chartDescription?.text = "Sleep Hours vs Activity"
        chart.setScaleMinima(1, scaleY: 1)
    }
    
    public static func updateSleepGraph(data: [(title: String, graph: [Double])], chart: BarChartView) {
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
        chart.chartDescription?.text = "Sleep"

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
    
    public static func getDayOfWeek(date: String) -> String{
        let df  = DateFormatter()
        df.dateFormat = "YYYY-MM-dd"
        let date = df.date(from: date)!
        df.dateFormat = "EEEE"
        let day = df.string(from: date);
        let index = day.index(day.startIndex, offsetBy: 3)
        let parsedDay = day[..<index]
        return String(parsedDay)
    }
    
    private class BarChartFormatter: NSObject, IAxisValueFormatter {
        
        var labels: [String] = []
        
        func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            return labels[Int(value)]
        }
        
        init(labels: [String]) {
            super.init()
            self.labels = labels
        }
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

