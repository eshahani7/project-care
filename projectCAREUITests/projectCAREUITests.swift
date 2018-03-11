//
//  projectCAREUITests.swift
//  projectCAREUITests
//
//  Created by Ekta Shahani on 2/1/18.
//  Copyright © 2018 Ekta Shahani. All rights reserved.
//

import XCTest

class projectCAREUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        
        let app = XCUIApplication()
        XCTAssert(app.navigationBars["CARE"].otherElements["CARE"].exists)
        app.navigationBars["CARE"].otherElements["CARE"].tap()
        app.staticTexts["Steps"].tap()
        let element = app.otherElements.containing(.navigationBar, identifier:"CARE").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        element.children(matching: .button).element(boundBy: 0).tap()
        app.tables/*@START_MENU_TOKEN@*/.cells.containing(.staticText, identifier:"10")/*[[".cells.containing(.staticText, identifier:\"10.0 MIN.\")",".cells.containing(.staticText, identifier:\"03-10-2018\")",".cells.containing(.staticText, identifier:\"10\")"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.buttons["Button"].tap()
        
        XCTAssert(app.staticTexts["Heart Rate VS. Time"].exists)
        
        XCTAssert(app.staticTexts["Average Heart Rate"].exists)
        let averageHeartRateStaticText = app.staticTexts["Average Heart Rate"]
        averageHeartRateStaticText.tap()
        XCTAssert(app.staticTexts["Goal Met"].exists)
        XCTAssert(app.staticTexts["Heart Rate VS. Time"].exists)
        XCTAssert(app.staticTexts["Calories Burned"].exists)
        XCTAssert(app.staticTexts["User Entered Time"].exists)
        XCTAssert(app.staticTexts["Duration"].exists)
        XCTAssert(app.staticTexts["Workout Insights"].exists)
        app.staticTexts["Goal Met"].tap()
        app.staticTexts["Calories Burned"].tap()
        app.staticTexts["User Entered Time"].tap()
        app.staticTexts["Duration"].tap()
        app.staticTexts["Calorie Burn Goal"].tap()
        app.staticTexts["Heart Rate VS. Time"].tap()
        
        let workoutInsightsNavigationBar = app.navigationBars["Workout Insights"]
        workoutInsightsNavigationBar.staticTexts["Workout Insights"].tap()
        workoutInsightsNavigationBar.buttons["Select a Workout"].tap()
        
        let selectAWorkoutNavigationBar = app.navigationBars["Select a Workout"]
        selectAWorkoutNavigationBar.staticTexts["Select a Workout"].tap()
        selectAWorkoutNavigationBar.buttons["CARE"].tap()
        element.children(matching: .button).element(boundBy: 1).tap()
        app.staticTexts["Sleep VS. Activity"].tap()
        
        let sleepInsightsNavigationBar = app.navigationBars["Sleep Insights"]
        sleepInsightsNavigationBar.staticTexts["Sleep Insights"].tap()
        
        let scrollViewsQuery = app.scrollViews
        let elementsQuery = scrollViewsQuery.otherElements
        elementsQuery.staticTexts["Average Sleep"].tap()
        elementsQuery.staticTexts["Average Activity"].tap()
        elementsQuery.staticTexts["Minimum Activity"].tap()
        elementsQuery.staticTexts["Minimum Sleep"].tap()
        elementsQuery.staticTexts["Maximum Sleep"].tap()
        elementsQuery.staticTexts["Maximum Activity"].tap()
        XCTAssert(app.staticTexts["Maximum Sleep"].exists)
        XCTAssert(app.staticTexts["Maximum Activity"].exists)
        XCTAssert(app.staticTexts["Minimum Sleep"].exists)
        XCTAssert(app.staticTexts["Minimum Activity"].exists)
        //XCTAssert(app.navigationBars["Sleep Insights"].buttons["CARE"].exists)

        sleepInsightsNavigationBar.buttons["CARE"].tap()
        element.children(matching: .button).element(boundBy: 2).tap()
        
        let heartRateStatisticsNavigationBar = app.navigationBars["Heart Rate Statistics"]
        heartRateStatisticsNavigationBar.staticTexts["Heart Rate Statistics"].tap()
        app.staticTexts["Welcome back Aditya, Things look alright."].tap()
        averageHeartRateStaticText.tap()
        app.staticTexts["Minimum Heart Rate"].tap()
        app.staticTexts["Maximum Heart Rate"].tap()
        XCTAssert(app.staticTexts["Minimum Heart Rate"].exists)
        XCTAssert(app.staticTexts["Maximum Heart Rate"].exists)
        heartRateStatisticsNavigationBar.buttons["CARE"].tap()
        
    }
    
}
