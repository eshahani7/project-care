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
        print("testing")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        print("done testing")
        super.tearDown()
    }
    
    func testConstructor() {
        let wu:WorkoutUtilities = WorkoutUtilities(workoutMins: 20, intensityLevel: 2)
        XCTAssertNotNil(wu)
    }
    
    func testIsTooFast() {
        let wu:WorkoutUtilities = WorkoutUtilities(workoutMins: 20, intensityLevel: 2)
        let maxHR:Double = 225
        let tooFast:Bool = wu.isTooFast(currHR: maxHR)
        XCTAssertEqual(tooFast, true)
    }
    
    func testIsTooSlow() {
        let wu:WorkoutUtilities = WorkoutUtilities(workoutMins: 20, intensityLevel: 2)
        let minHR:Double = 0
        let tooSlow:Bool = wu.isTooSlow(currHR: minHR)
        XCTAssertEqual(tooSlow, true)
    }
    
    func testCalBurn() {
        let wu:WorkoutUtilities = WorkoutUtilities(workoutMins: 20, intensityLevel: 2)
        let calsBurned:Double = wu.predictCalorieBurn()
        XCTAssertEqual(round(calsBurned), 114)
    }
    
}
