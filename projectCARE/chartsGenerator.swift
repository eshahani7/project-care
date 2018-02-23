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
    public static func createStepsChart(barsData: [(title: String, min: Int, max: Int)], width: CGFloat, height: CGFloat) -> Chart {
        
        let font = UIFont(name: "Avenir", size: 12)
        let labelSettings = ChartLabelSettings(font: font!, fontColor: UIColor.white)
        
        let alpha: CGFloat = 0.2
        let color = UIColor.lightGray.withAlphaComponent(alpha)
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
        
        // These models define specifics for each of the axes, and define the bounds
        let xModel = ChartAxisModel(firstModelValue: -1, lastModelValue: Double(barsData.count), axisTitleLabels: [ChartAxisLabel(text: "Days", settings: labelSettings)], axisValuesGenerator: xGenerator, labelsGenerator: labelsGenerator)
        let yModel = ChartAxisModel(firstModelValue: 0, lastModelValue: 6400, axisTitleLabels: [ChartAxisLabel(text: "Step Count", settings: labelSettings.defaultVertical())], axisValuesGenerator: yGenerator, labelsGenerator: labelsGenerator)
        
        let chartFrame = CGRect(x: 0, y: 40, width: width - 10, height: height - 40)
        
        // Defines the coordinate layer
        let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: ChartSettings(), chartFrame: chartFrame, xModel: xModel, yModel: yModel)
        let (xAxisLayer, yAxisLayer, innerFrame) = (coordsSpace.xAxisLayer, coordsSpace.yAxisLayer, coordsSpace.chartInnerFrame)
        
        // Actual bars on the chart
        let barViewSettings = ChartBarViewSettings()
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
            label.textColor = UIColor.white
            label.font = font!
            label.sizeToFit()
            label.center = CGPoint(x: chartPointModel.screenLoc.x, y: pos ? innerFrame.origin.y: innerFrame.origin.y + innerFrame.size.height)
            label.alpha = 0
            
            label.movedToSuperViewHandler = {[weak label] in
                UIView.animate(withDuration: 0, animations: {
                    label?.alpha = 1
                    label?.center.y = chartPointModel.screenLoc.y - 10
                })
            }
            return label
            
        }, displayDelay: 0, mode: .translate) // show after bars animation
        
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
    
    public static func createWorkoutChart(pointsData: [(heartRate: Double, timeSinceStart: Double)], width: CGFloat, height: CGFloat) -> Chart {
        let font = UIFont(name: "Avenir", size: 12)
        let labelSettings = ChartLabelSettings(font: font!, fontColor: UIColor.white)
    
        let alpha: CGFloat = 0.2
        let color = UIColor.lightGray.withAlphaComponent(alpha)
        //let zero = ChartAxisValueInt(0)
        
        // ChartPoint(x: ChartAxisValueDouble($0.0, labelSettings: labelSettings), y: ChartAxisValueDouble($0.1))
        let points: [ChartPoint] = pointsData.map{ChartPoint(x: ChartAxisValueDouble($0.1), y: ChartAxisValueDouble($0.0, labelSettings: labelSettings))}
        //let points: [ChartPoint] = [(1, 3), (2, 5), (3, 7.5), (4, 10), (5, 6), (6, 12)].map{ChartPoint(x: ChartAxisValueDouble($0.0, labelSettings: labelSettings), y: ChartAxisValueDouble($0.1))}
        
        let xValues = points.map{$0.x}
        let yValues = ChartAxisValuesStaticGenerator.generateYAxisValuesWithChartPoints(points, minSegmentCount: 10, maxSegmentCount: 140, multiple: 20, axisValueGenerator: {ChartAxisValueDouble($0, labelSettings: labelSettings)}, addPaddingSegmentIfEdge: false)
    
        let lineModel = ChartLineModel(chartPoints: points, lineColor: color, animDuration: 1, animDelay: 0)
        
        // These models define specifics for each of the axes, and define the bounds
        let xModel = ChartAxisModel(axisValues: xValues, axisTitleLabel: ChartAxisLabel(text: "Minute", settings: labelSettings))
        let yModel = ChartAxisModel(axisValues: yValues, axisTitleLabel: ChartAxisLabel(text: "Heart Rate", settings: labelSettings.defaultVertical()))
   
        
        let chartFrame = CGRect(x: 0, y: 40, width: width - 10, height: height - 40)
        
    
    let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: ChartSettings(), chartFrame: chartFrame, xModel: xModel, yModel: yModel)
    let (xAxisLayer, yAxisLayer, innerFrame) = (coordsSpace.xAxisLayer, coordsSpace.yAxisLayer, coordsSpace.chartInnerFrame)
    
    let chartPointsLineLayer = ChartPointsLineLayer(xAxis: xAxisLayer.axis, yAxis: yAxisLayer.axis, lineModels: [lineModel])
    
    
    let settings = ChartGuideLinesDottedLayerSettings(linesColor: UIColor.black, linesWidth:2)
    let guidelinesLayer = ChartGuideLinesDottedLayer(xAxisLayer: xAxisLayer, yAxisLayer: yAxisLayer, settings: settings)
    
    let chart = Chart(
        frame: chartFrame,
        innerFrame: innerFrame,
        settings: ChartSettings(),
        layers: [
            xAxisLayer,
            yAxisLayer,
            guidelinesLayer,
            chartPointsLineLayer,
        ]
    )
    
//    view.addSubview(chart.view)
//    self.chart = chart
        
        return chart
    }
}
