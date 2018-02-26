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
    
//    public static func createStepsChart(barsData: [(title: String, min: Int, max: Int)], width: CGFloat, height: CGFloat) -> Chart {
//
//    }
//
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
        chtChart.setScaleMinima(1, scaleY: 6000)
    }


//    public static func createWorkoutChart(pointsData: [(heartRate: Double, timeSinceStart: Double)], width: CGFloat, height: CGFloat) -> Chart {
//        let font = UIFont(name: "Avenir", size: 12)
//        let labelSettings = ChartLabelSettings(font: font!, fontColor: UIColor.white)
//
//        let alpha: CGFloat = 0.2
//        let color = UIColor.lightGray.withAlphaComponent(alpha)
//        //let zero = ChartAxisValueInt(0)
//
//        // ChartPoint(x: ChartAxisValueDouble($0.0, labelSettings: labelSettings), y: ChartAxisValueDouble($0.1))
//        let points: [ChartPoint] = pointsData.map{ChartPoint(x: ChartAxisValueDouble($0.1), y: ChartAxisValueDouble($0.0, labelSettings: labelSettings))}
//
//
//
//        let xValues = points.map{$0.x}
//        let yValues = ChartAxisValuesStaticGenerator.generateYAxisValuesWithChartPoints(points, minSegmentCount: 10, maxSegmentCount: 140, multiple: 20, axisValueGenerator: {ChartAxisValueDouble($0, labelSettings: labelSettings)}, addPaddingSegmentIfEdge: true)
//
////        let labelsGenerator = ChartAxisLabelsGeneratorFunc {scalar in
////            return ChartAxisLabel(text: "M", settings: labelSettings)
////        }
//
//        let lineModel = ChartLineModel(chartPoints: points, lineColor: UIColor.red, animDuration: 1, animDelay: 0)
//
//        //These models define specifics for each of the axes, and define the bounds
//        let xModel = ChartAxisModel(axisValues: xValues, axisTitleLabel: ChartAxisLabel(text: "Minute", settings: labelSettings))
//        let yModel = ChartAxisModel(axisValues: yValues, axisTitleLabel: ChartAxisLabel(text: "Heart Rate", settings: labelSettings.defaultVertical()))
//
//
//        let chartFrame = CGRect(x: 0, y: 40, width: width - 10, height: height - 40)
//
//
//    let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: ChartSettings(), chartFrame: chartFrame, xModel: xModel, yModel: yModel)
//    let (xAxisLayer, yAxisLayer, innerFrame) = (coordsSpace.xAxisLayer, coordsSpace.yAxisLayer, coordsSpace.chartInnerFrame)
//
//    let chartPointsLineLayer = ChartPointsLineLayer(xAxis: xAxisLayer.axis, yAxis: yAxisLayer.axis, lineModels: [lineModel])
//
//
//    let settings = ChartGuideLinesDottedLayerSettings(linesColor: UIColor.black, linesWidth:2)
//    let guidelinesLayer = ChartGuideLinesDottedLayer(xAxisLayer: xAxisLayer, yAxisLayer: yAxisLayer, settings: settings)
//
////        let chartConfig = ChartConfigXY(
////            chartSettings: ChartSettings(),
////            xAxisConfig: ChartAxisConfig(from: 0, to: 3, by: 0.5),
////            yAxisConfig: ChartAxisConfig(from: 0, to: 150, by: 20),
////            xAxisLabelSettings:labelSettings,
////            yAxisLabelSettings:labelSettings.defaultVertical()
////        )
////
////        let chart = LineChart(
////            frame: chartFrame,
////            chartConfig: chartConfig,
////            xTitle: "Minutes",
////            yTitle: "Heart Rate",
////            lines: [(chartPoints: pointsData, color: color)]
////        )
////
//
//    let chart = Chart(
//        frame: chartFrame,
//        innerFrame: innerFrame,
//        settings: ChartSettings(),
//        layers: [
//            xAxisLayer,
//            yAxisLayer,
//            guidelinesLayer,
//            chartPointsLineLayer,
//        ]
//    )
//        return chart
//    }
//
//    public static func createSleepActivityChart(groupsData: [(title: String, [(min: Double, max: Double)])], horizontal: Bool, width: CGFloat, height: CGFloat) -> Chart {
//
//        var chart: Chart?
//        let font = UIFont(name: "Avenir", size: 20)
//        let labelSettings = ChartLabelSettings(font: font!, fontColor: UIColor.white)
//
//        let groupColors = [UIColor.red.withAlphaComponent(0.6), UIColor.blue.withAlphaComponent(0.6)]
//
//        let groups: [ChartPointsBarGroup] = groupsData.enumerated().map {index, entry in
//            let constant = ChartAxisValueDouble(index)
//            let bars = entry.1.enumerated().map {index, tuple in
//                ChartBarModel(constant: constant, axisValue1: ChartAxisValueDouble(tuple.min), axisValue2: ChartAxisValueDouble(tuple.max), bgColor: groupColors[index])
//            }
//            return ChartPointsBarGroup(constant: constant, bars: bars)
//        }
//
//        let (axisValues1, axisValues2): ([ChartAxisValueDouble], [ChartAxisValue]) = (
//            stride(from: 0, through: 60, by: 5).map {ChartAxisValueDouble(Double($0), labelSettings: labelSettings)},
//            [ChartAxisValueString(order: -1)] +
//                groupsData.enumerated().map {index, tuple in ChartAxisValueString(tuple.0, order: index, labelSettings: labelSettings)} +
//                [ChartAxisValueString(order: groupsData.count)]
//        )
//        let (xValues, yValues) = horizontal ? (axisValues1, axisValues2) : (axisValues2, axisValues1)
//
//        let xModel = ChartAxisModel(axisValues: xValues, axisTitleLabel: ChartAxisLabel(text: "Sleep and Activity per day", settings: labelSettings))
//        let yModel = ChartAxisModel(axisValues: yValues, axisTitleLabel: ChartAxisLabel(text: "Hours", settings: labelSettings.defaultVertical()))
//        let chartFrame = CGRect(x: 0, y: -400, width: width - 10, height: height + 200)
////        let chartFrame = chart?.frame ?? CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: frame.size.height - dirSelectorHeight)
//
//        var chartSettings = ChartSettings()
////        chartSettings.leading = 100
//        chartSettings.axisStrokeWidth = 4
//
//        let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: chartSettings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
//        let (xAxisLayer, yAxisLayer, innerFrame) = (coordsSpace.xAxisLayer, coordsSpace.yAxisLayer, coordsSpace.chartInnerFrame)
//
//        let barViewSettings = ChartBarViewSettings(animDuration: 0.1, selectionViewUpdater: ChartViewSelectorBrightness(selectedFactor: 0.5))
//
//        let groupsLayer = ChartGroupedPlainBarsLayer(xAxis: xAxisLayer.axis, yAxis: yAxisLayer.axis, groups: groups, horizontal: horizontal, barSpacing: 2, groupSpacing: 25, settings: barViewSettings, tapHandler: { tappedGroupBar /*ChartTappedGroupBar*/ in
//
//            let barPoint = horizontal ? CGPoint(x: tappedGroupBar.tappedBar.view.frame.maxX, y: tappedGroupBar.tappedBar.view.frame.midY) : CGPoint(x: tappedGroupBar.tappedBar.view.frame.midX, y: tappedGroupBar.tappedBar.view.frame.minY)
//
//            guard let chart = chart, let chartViewPoint = tappedGroupBar.layer.contentToGlobalCoordinates(barPoint) else {return}
//
//            let viewPoint = CGPoint(x: chartViewPoint.x, y: chartViewPoint.y)
//
//            let infoBubble = InfoBubble(point: viewPoint, preferredSize: CGSize(width: 50, height: 40), superview: chart.view, text: tappedGroupBar.tappedBar.model.axisValue2.description, font: font!, textColor: UIColor.white, bgColor: UIColor.gray, horizontal: horizontal)
//
//            let anchor: CGPoint = {
//                switch (horizontal, infoBubble.inverted(chart.view)) {
//                case (true, true): return CGPoint(x: 1, y: 0.5)
//                case (true, false): return CGPoint(x: 0, y: 0.5)
//                case (false, true): return CGPoint(x: 0.5, y: 0)
//                case (false, false): return CGPoint(x: 0.5, y: 1)
//                }
//            }()
//
//            let animatorsSettings = ChartViewAnimatorsSettings(animInitSpringVelocity: 1)
//            let animators = ChartViewAnimators(view: infoBubble, animators: ChartViewGrowAnimator(anchor: anchor), settings: animatorsSettings, invertSettings: animatorsSettings.withoutDamping(), onFinishInverts: {
//                infoBubble.removeFromSuperview()
//            })
//
//            chart.view.addSubview(infoBubble)
//
//            infoBubble.tapHandler = {
//                animators.invert()
//            }
//
//            animators.animate()
//        })
//
//        let guidelinesSettings = ChartGuideLinesLayerSettings(linesColor: UIColor.white, linesWidth: 5)
//        let guidelinesLayer = ChartGuideLinesLayer(xAxisLayer: xAxisLayer, yAxisLayer: yAxisLayer, axis: horizontal ? .x : .y, settings: guidelinesSettings)
//
//        return Chart(
//            frame: chartFrame,
//            innerFrame: innerFrame,
//            settings: chartSettings,
//            layers: [
//                xAxisLayer,
//                yAxisLayer,
//                guidelinesLayer,
//                groupsLayer
//            ]
//        )
//
//    }
}

