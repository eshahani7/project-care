//
//  WorkoutUtilitiesTests.swift
//  projectCARE
//
//  Created by Ekta Shahani on 2/21/18.
//  Copyright © 2018 Ekta Shahani. All rights reserved.
//
import XCTest

class WorkoutUtilitiesTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testConstructor() {
        let wu:WorkoutUtilities = WorkoutUtilities(workoutMins: 20, intensityLevel: 2)
        XCTAssertNotNil(wu)
    }
    
    func testIsTooFast() {
        let wu:WorkoutUtilities = WorkoutUtilities(workoutMins: 20, intensityLevel: 2)
        let maxHR:Double = 225
        let time:Date = Date()
        let tooFast:Bool = wu.isTooFast(currHR: maxHR, startDate: time)
        XCTAssertEqual(tooFast, true)
    }
    
    func testIsTooSlow() {
        let wu:WorkoutUtilities = WorkoutUtilities(workoutMins: 20, intensityLevel: 2)
        let minHR:Double = 0
        let time:Date = Date().addingTimeInterval(-60*10)
        let tooSlow:Bool = wu.isTooSlow(currHR: minHR, startDate: time)
        XCTAssertEqual(tooSlow, true)
    }
    
    func testIsTooFastWarmUp() {
        let wu:WorkoutUtilities = WorkoutUtilities(workoutMins: 20, intensityLevel: 2)
        let maxHR:Double = 225
        let time:Date = Date()
        let tooFast:Bool = wu.isTooFast(currHR: maxHR, startDate: time)
        XCTAssertEqual(tooFast, true)
    }
    
    func testIsTooSlowCoolDown() {
        let wu:WorkoutUtilities = WorkoutUtilities(workoutMins: 20, intensityLevel: 2)
        let minHR:Double = 0
        let time:Date = Date().addingTimeInterval(-60*18)
        let tooSlow:Bool = wu.isTooSlow(currHR: minHR, startDate: time)
        XCTAssertEqual(tooSlow, true)
    }
    
    func testCalBurn() {
        let wu:WorkoutUtilities = WorkoutUtilities(workoutMins: 20, intensityLevel: 2)
        let calsBurned:Double = wu.predictCalorieBurn()
        XCTAssertEqual(round(calsBurned), 114)
    }
    
 }
