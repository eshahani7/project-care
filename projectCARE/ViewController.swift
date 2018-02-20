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
        
        let font = UIFont(name: "Avenir", size: 17)
        let labelSettings = ChartLabelSettings(font: font!)
        
        // Get the data for the past 7 days and put into correct format for barsData.
        
        // Use Statistics HK to calculate mean step counts for the past 7 days.
        
        let barsData: [(title: String, min: Double, max: Double)] = [
            ("A", 0, 40),
            ("B", 0, 50),
            ("C", 0, 35),
            ("D", 0, 40),
            ("E", 0, 30),
            ("F", 0, 47),
            ("G", 0, 60)
        ]
        
        let alpha: CGFloat = 0.5
        let color = UIColor.gray.withAlphaComponent(alpha)
        let zero = ChartAxisValueDouble(0)
        let bars: [ChartBarModel] = barsData.enumerated().flatMap {index, tuple in
            [
                ChartBarModel(constant: ChartAxisValueDouble(index), axisValue1: zero, axisValue2: ChartAxisValueDouble(tuple.max), bgColor: color)
            ]
        }
        
        // THe generator represents the scale for the charts
        let xGenerator = ChartAxisGeneratorMultiplier(1)
        let yGenerator = ChartAxisGeneratorMultiplier(20)
        
        
        let labelsGenerator = ChartAxisLabelsGeneratorFunc {scalar in
            return ChartAxisLabel(text: "\(scalar)", settings: labelSettings)
        }
        
        // These models define specifics for each of the axes, and define the bounds
        let xModel = ChartAxisModel(firstModelValue: -1, lastModelValue: Double(barsData.count), axisTitleLabels: [ChartAxisLabel(text: "X AXIS title", settings: labelSettings)], axisValuesGenerator: xGenerator, labelsGenerator: labelsGenerator)
        let yModel = ChartAxisModel(firstModelValue: 0, lastModelValue: 80, axisTitleLabels: [ChartAxisLabel(text: "Y Axis title", settings: labelSettings.defaultVertical())], axisValuesGenerator: yGenerator, labelsGenerator: labelsGenerator)
        
        // Sets the frame size of the chart
        //        var iPhoneChartSettings: ChartSettings {
        //            var chartSettings = ChartSettings()
        //            chartSettings.leading = 10
        //            chartSettings.top = 10
        //            chartSettings.trailing = 10
        //            chartSettings.bottom = 10
        //            chartSettings.labelsToAxisSpacingX = 5
        //            chartSettings.labelsToAxisSpacingY = 5
        //            chartSettings.axisTitleLabelsToLabelsSpacing = 4
        //            chartSettings.axisStrokeWidth = 0.2
        //            chartSettings.spacingBetweenAxesX = 8
        //            chartSettings.spacingBetweenAxesY = 8
        //            chartSettings.labelsSpacing = 0
        //            chartSettings.zoomPan.panEnabled = true
        //            chartSettings.zoomPan.zoomEnabled = true
        //            return chartSettings
        //        }
        
        let chartFrame = CGRect(x: 0, y: 70, width: view.bounds.size.width - 50, height: view.bounds.size.height - 80)
        //let chartFrame = view.bounds
        
        // Defines the coordinate layer
        let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: ChartSettings(), chartFrame: chartFrame, xModel: xModel, yModel: yModel)
        let (xAxisLayer, yAxisLayer, innerFrame) = (coordsSpace.xAxisLayer, coordsSpace.yAxisLayer, coordsSpace.chartInnerFrame)
        
        // Actual bars on the chart
        let barViewSettings = ChartBarViewSettings(animDuration: 0.5)
        let barsLayer = ChartBarsLayer(xAxis: xAxisLayer.axis, yAxis: yAxisLayer.axis, bars: bars, horizontal: false, barWidth: 25, settings: barViewSettings)
        
        let labelToBarSpace: Double = 3 // domain units
        let labelChartPoints = bars.map {bar in
            ChartPoint(x: bar.constant, y: bar.axisValue2.copy(bar.axisValue2.scalar + (bar.axisValue2.scalar > 0 ? labelToBarSpace : -labelToBarSpace)))
        }
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        let labelsLayer = ChartPointsViewsLayer(xAxis: xAxisLayer.axis, yAxis: yAxisLayer.axis, chartPoints: labelChartPoints, viewGenerator: {(chartPointModel, layer, chart) -> UIView? in
            let label = HandlingLabel()
            
            let pos = chartPointModel.chartPoint.y.scalar > 0
            
            label.text = "\(formatter.string(from: NSNumber(value: chartPointModel.chartPoint.y.scalar - labelToBarSpace))!)%"
            label.font = font!
            label.sizeToFit()
            label.center = CGPoint(x: chartPointModel.screenLoc.x, y: pos ? innerFrame.origin.y : innerFrame.origin.y + innerFrame.size.height)
            label.alpha = 0
            
            label.movedToSuperViewHandler = {[weak label] in
                UIView.animate(withDuration: 0.3, animations: {
                    label?.alpha = 1
                    label?.center.y = chartPointModel.screenLoc.y
                })
            }
            return label
            
        }, displayDelay: 0.5, mode: .translate) // show after bars animation
        
        let chart = Chart(
            frame: chartFrame,
            innerFrame: innerFrame,
            settings: ChartSettings(),
            layers: [
                xAxisLayer,
                yAxisLayer,
                barsLayer,
                labelsLayer
            ]
        )
        
        view.addSubview(chart.view)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

