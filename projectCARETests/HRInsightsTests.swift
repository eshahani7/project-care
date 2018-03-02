//
//  HRInsightsTests.swift
//  projectCARE
//
//  Created by Ekta Shahani on 3/1/18.
//  Copyright © 2018 Ekta Shahani. All rights reserved.
//

import XCTest

class HRInsightsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testHRInit() {
        let insights = HeartRateInsights()
        XCTAssertNotNil(insights)
    }
    
    func testGetMaxHR() {
        let insights = HeartRateInsights()
        XCTAssertEqual(insights.getMaxHR(), 96)
    }
    
    func testGetMinHR() {
        let insights = HeartRateInsights()
        XCTAssertEqual(insights.getMinHR(), 94)
    }
    
    func testGetAvgHR() {
        let insights = HeartRateInsights()
        XCTAssertEqual(round(insights.getAvgHR()!), 95)
        
    }
    
    func testGetInsights() {
        let insights = HeartRateInsights()
        let expectedInsight = "Your resting heart rate is healthy, but on the higher end. Try adding at least 30 minutes of exercise 2-3 times a week to your routine."
        
        XCTAssertEqual(insights.getInsights(), expectedInsight)
    }
    
}
