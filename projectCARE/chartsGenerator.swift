//
//  chartsGenerator.swift
//  projectCARE
//
//  Created by admin on 2/21/18.
//  Copyright © 2018 Ekta Shahani. All rights reserved.
//

import Foundation
import UIKit
import SwiftCharts

class generateCharts {
    public static func createStepsChart(barsData: [(title: String, min: Int, max: Int)], view: UIView) -> Chart {
        
        let font = UIFont(name: "Avenir", size: 17)
        let labelSettings = ChartLabelSettings(font: font!)
        
        let alpha: CGFloat = 0.5
        let color = UIColor.gray.withAlphaComponent(alpha)
        let zero = ChartAxisValueInt(0)
        let bars: [ChartBarModel] = barsData.enumerated().flatMap {index, tuple in
            [
                ChartBarModel(constant: ChartAxisValueDouble(index), axisValue1: zero, axisValue2: ChartAxisValueDouble(tuple.max), bgColor: color)
            ]
        }
        
        // THe generator represents the scale for the charts
        let xGenerator = ChartAxisGeneratorMultiplier(1)
        let yGenerator = ChartAxisGeneratorMultiplier(1000)
        
        
        let labelsGenerator = ChartAxisLabelsGeneratorFunc {scalar in
            return ChartAxisLabel(text: "\(scalar)", settings: labelSettings)
        }
        
        // For the horizontal axis, the labels should be the days of the week along with the date range of the week for the past week.
        
        // These models define specifics for each of the axes, and define the bounds
        let xModel = ChartAxisModel(firstModelValue: -1, lastModelValue: Double(barsData.count), axisTitleLabels: [ChartAxisLabel(text: "Days", settings: labelSettings)], axisValuesGenerator: xGenerator, labelsGenerator: labelsGenerator)
        let yModel = ChartAxisModel(firstModelValue: 0, lastModelValue: 6500, axisTitleLabels: [ChartAxisLabel(text: "Step Count", settings: labelSettings.defaultVertical())], axisValuesGenerator: yGenerator, labelsGenerator: labelsGenerator)
        
        let chartFrame = CGRect(x: 0, y: 40, width: view.bounds.size.width - 10, height: view.bounds.size.height - 40)
        
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
            
            label.text = "\(formatter.string(from: NSNumber(value: chartPointModel.chartPoint.y.scalar - labelToBarSpace))!)"
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
        
        return chart
    }
}
