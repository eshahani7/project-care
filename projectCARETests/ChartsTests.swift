//
//  ChartsTests.swift .swift
//  projectCARETests
//
//  Created by Anu Polisetty on 3/3/18.
//  Copyright © 2018 Ekta Shahani. All rights reserved.
//

import Foundation
import XCTest
import Charts
class ChartsTests: XCTestCase {
  
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
//    func testStepCountChart() {
//        var nums: [Int] = [1,2,3,4,5,6,7]
//        let testChart = BarChartView();
//        generateCharts.updateStepsGraph(stepsData:nums, chtChart:testChart);
//
//        for i in 0..<nums.count {
//            XCTAssertEqual(nums[i], testChart.data?.dataSets.index(after: i) )
//        }
//
//    }
    
    func testStepActivityGraph() {
        //var sleep:[(title: String, graph: [Double])] = [(title: "Sleep", graph: [5.0, 5.0,5.0,5.0])]
        //var activity:[(title: String, graph: [Double])] = [(title: "Activity", graph: [7.0, 7.0, 7.0, 7.0])]
        
        var sleepData : [(title: String, graph: [Double])] = []
        var activityData : [(title: String, graph: [Double])] = []
        
        for i in 0..<5 {
            activityData.append((title: "2018-03-03" , graph: [25.0]))
        }
        
        for i in 0..<5 {
            sleepData.append((title: "2018-03-03" , graph: [7.0]))
        }
        
        let testChart = BarChartView();
        generateCharts.updateSleepActivityGraph(sleepData: sleepData, activityData: activityData, chart:testChart);
        
        for i in 0..<5 {
            XCTAssertEqual(25.0,  testChart.data?.dataSets[1].entryForIndex(i)?.y)
        }
        for i in 0..<5 {
            XCTAssertEqual(7.0,  testChart.data?.dataSets[0].entryForIndex(i)?.y)
        }
       

    }
    
    func testHRWorkoutGraph(){
        var HRWorkoutData:[(heartRate: Double, timeSinceStart:Double)] = [  (heartRate: 95.0, timeSinceStart: 0.0),(heartRate: 95.0, timeSinceStart: 1.0),(heartRate: 95.0, timeSinceStart: 2.0),(heartRate: 95.0, timeSinceStart: 3.0)]
         let testChart = ScatterChartView();
        
        generateCharts.updateHRWorkoutGraph(data: HRWorkoutData, chart:testChart)
        
        
        for i in 0..<HRWorkoutData.count {
            XCTAssertEqual(HRWorkoutData[i].heartRate,  testChart.data?.dataSets[0].entryForIndex(i)?.y)
            
            XCTAssertEqual((HRWorkoutData[i].timeSinceStart)/60,  testChart.data?.dataSets[0].entryForIndex(i)?.x)
            
        }
        
    }
}   
