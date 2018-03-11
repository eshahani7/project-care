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
    init(){
        
    }
    
    public static func updateStepsGraph(stepsData: [(title: String, stepCount: Int)], chtChart: BarChartView) {
        var barChartEntry = [BarChartDataEntry]()
        var xValues = [String]()
        print(stepsData)
        
        var date = Calendar.current.date(byAdding: .day, value: -7, to: Date())
        let endDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        let fmt = DateFormatter()
        fmt.dateFormat = "YYYY-MM-dd"
        while (date?.compare(endDate!) != .orderedDescending) {
            xValues.append(getDayOfWeek(date: fmt.string(from: date!)))
            date = Calendar.current.date(byAdding: .day, value: 1, to: date!)!
        }
        //print(xValues)

        if(stepsData.count != 0){
            for i in 0..<stepsData.count {
                let value = BarChartDataEntry(x: Double(i), y: Double(stepsData[i].stepCount))
                barChartEntry.append(value)
            }
        } else {
            // throw something here
        }
        
        let barChartDataSet = BarChartDataSet(values: barChartEntry, label: "Step count")
        let data = BarChartData(dataSet: barChartDataSet)
        chtChart.data = data
        
        //bar chart animation
        chtChart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeOutExpo)
        chtChart.chartDescription?.text = "Step counts vs Time"

        let chartFormatter = BarChartFormatter(labels: xValues)
        let xAxis = XAxis()
        xAxis.valueFormatter = chartFormatter
        chtChart.xAxis.valueFormatter = xAxis.valueFormatter

        chtChart.chartDescription?.textColor = UIColor(red: 0.8902, green: 0.902, blue: 0.9137, alpha: 0.75)
        chtChart.chartDescription?.font = UIFont.systemFont(ofSize: 100, weight: UIFont.Weight.regular)
        chtChart.chartDescription?.position = CGPoint(x: 200, y: 500)

        chtChart.setScaleMinima(1, scaleY: 1)
        
        chtChart.xAxis.labelPosition = .bottom
        chtChart.xAxis.drawGridLinesEnabled = false
        chtChart.xAxis.labelTextColor = UIColor(red: 0.8902, green: 0.902, blue: 0.9137, alpha: 0.75)
        chtChart.legend.textColor = UIColor(red: 0.8902, green: 0.902, blue: 0.9137, alpha: 0.75)

        chtChart.rightAxis.enabled = false
        chtChart.leftAxis.drawGridLinesEnabled = false
        chtChart.leftAxis.labelTextColor = UIColor(red: 0.8902, green: 0.902, blue: 0.9137, alpha: 0.75)
        chtChart.drawGridBackgroundEnabled = false
        chtChart.barData?.setValueTextColor(UIColor(red: 0.8902, green: 0.902, blue: 0.9137, alpha: 0.75))

        chtChart.drawValueAboveBarEnabled = true
        chtChart.gridBackgroundColor = UIColor.white
        barChartDataSet.colors = [UIColor(red: 1, green: 0.8196, blue: 0.9373, alpha: 1)]
        barChartDataSet.setColor(UIColor(red: 1, green: 0.8196, blue: 0.9373, alpha: 1))
        
        
    }

    public static func updateSleepActivityGraph(sleepData: [(title: String, graph: [Double])], activityData: [(title: String, graph: [Double])], chart: BarChartView) {
        var barChartSleepEntry = [BarChartDataEntry]()
        var barChartActivityEntry = [BarChartDataEntry]()

        var xValues = [String]()
//        print("sleepData!!!")
//        print(sleepData)
        
        if(sleepData.count != 0) {
            for i in 0...sleepData.count - 1 {
                // Get index of date in sleepData. Then, append to barChartSleepEntry?!?
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

//        for i in 0...activityData.count - 1 {
//            let value = BarChartDataEntry(x: Double(i), y: Double(activityData[i].graph[0]))
//            barChartActivityEntry.append(value)
//        }

        let data = BarChartData()
        data.addDataSet(barChartSleepDataSet)
        data.addDataSet(barChartActivityDataSet)
        chart.data = data

        
        chart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeOutExpo)
        chart.chartDescription?.text = ""
        chart.setScaleMinima(1, scaleY: 1)
        
        chart.xAxis.labelPosition = .bottom

        //chart.legend.textColor = UIColor.white
        //chart.xAxis.labelTextColor = UIColor.white
        //chart.leftAxis.labelTextColor = UIColor.white

        chart.xAxis.drawGridLinesEnabled = false
        chart.xAxis.labelTextColor = UIColor(red: 0.8902, green: 0.902, blue: 0.9137, alpha: 0.75)
        chart.legend.textColor = UIColor.white
        chart.leftAxis.drawGridLinesEnabled = false
        chart.leftAxis.labelTextColor = UIColor(red: 0.8902, green: 0.902, blue: 0.9137, alpha: 0.75)
        chart.rightAxis.enabled = false
        chart.barData?.setValueTextColor(UIColor(red: 0.8902, green: 0.902, blue: 0.9137, alpha: 0.75))

        //chart.backgroundColor = UIColor.white
        chart.drawValueAboveBarEnabled = true
        chart.drawGridBackgroundEnabled = false
        
        barChartSleepDataSet.colors = [UIColor(red: 1, green: 0.8196, blue: 0.9373, alpha: 1)]
        barChartActivityDataSet.colors = [UIColor.black]
    

        chart.chartDescription?.text = "Sleep Hours vs Activity"
        chart.setScaleMinima(1, scaleY: 1)

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
            //print("Count: " + String(labels.count))
            if (value <= Double(labels.count)) {
                //print(value)
                return labels[Int(value)];
            }
            return "no work";
        }
        init(labels: [String]) {
            super.init()
            self.labels = labels
        }
    }
    
    public static func updateHRWorkoutGraph(data: [(heartRate: Double, timeSinceStart:Double)], chart: ScatterChartView) {
        var dataEntry = [ChartDataEntry]()
        for i in 0..<data.count {
            let value1 = ChartDataEntry(x: (Double(data[i].timeSinceStart)/60.0) , y: Double(data[i].heartRate) )
            dataEntry.append(value1)
            print(value1)
        }
        let dataSet = ScatterChartDataSet(values: dataEntry, label: "HeartRate" )
        print(dataSet)
        dataSet.setColor(UIColor(red: 1, green: 0.298, blue: 0.3098, alpha: 1.0))
        var workoutHRDataSet = [ScatterChartDataSet]()
      
        workoutHRDataSet.append(dataSet)
        
        let data = ScatterChartData(dataSets:workoutHRDataSet)
        dataSet.setScatterShape(.circle)
        dataSet.scatterShapeSize = 6
        chart.data = data
        //chart.XAxisPosition = BOTTOM
        chart.chartDescription?.text = "Heart vs Activity"

        chart.setScaleMinima(1, scaleY: 1)
        
        chart.chartDescription?.textColor = UIColor(red: 0.8902, green: 0.902, blue: 0.9137, alpha: 0.75)
        chart.chartDescription?.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.regular)
        
        chart.rightAxis.enabled = false
        chart.leftAxis.labelTextColor = UIColor(red: 0.8902, green: 0.902, blue: 0.9137, alpha: 0.75)
        chart.xAxis.labelPosition = .bottom
        chart.xAxis.labelTextColor = UIColor(red: 0.8902, green: 0.902, blue: 0.9137, alpha: 0.75)
        chart.legend.textColor = UIColor(red: 0.8902, green: 0.902, blue: 0.9137, alpha: 0.75)
        
        
        

        chart.setVisibleXRange(minXRange: 0, maxXRange: 150)
        //chart.leftAxis.axisMinimum = 0;
        chart.xAxis.axisMinimum = 0;
        chart.setScaleMinima(0, scaleY: 0)
        chart.rightAxis.enabled=false

        print(data)

    }
    
  
}
