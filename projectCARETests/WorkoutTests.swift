//
//  WorkoutTests.swift
//  projectCARE
//
//  Created by Ekta Shahani on 2/21/18.
//  Copyright © 2018 Ekta Shahani. All rights reserved.
//

import XCTest

class WorkoutTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitWorkoutList() {
        let workoutList:WorkoutList = WorkoutList()
        XCTAssertNotNil(workoutList)
    }
    
    func testGetWorkoutList() {
        let workoutList:WorkoutList = WorkoutList()
        XCTAssertNotNil(workoutList.getWorkoutList())
    }
    
    //WorkoutFacade never instantiated directly, must get WorkoutList first
    func testGetWorkoutAvgHR() {
        let workoutList:WorkoutList = WorkoutList()
        let list:[WorkoutFacade] = workoutList.getWorkoutList()
        let seededHR:Double = 95
        
        XCTAssertEqual(list[0].getAvgHeartRate(), seededHR)
    }
    
    func testGetWorkoutCalsBurned() {
        let workoutList:WorkoutList = WorkoutList()
        let list:[WorkoutFacade] = workoutList.getWorkoutList()
        XCTAssertNotNil(list[0])
    }
    
    func testGetWorkoutDuration() {
        let workoutList:WorkoutList = WorkoutList()
        let list:[WorkoutFacade] = workoutList.getWorkoutList()
        let seededDuration:Double = 30.0 
        
        XCTAssertEqual(list[0].getDuration(), seededDuration)
    }
    
    func testGetWorkoutDist() {
        let workoutList:WorkoutList = WorkoutList()
        let list:[WorkoutFacade] = workoutList.getWorkoutList()
        XCTAssertNotNil(list[0])
    }
    
    func testGetWorkoutDate() {
        let workoutList:WorkoutList = WorkoutList()
        let list:[WorkoutFacade] = workoutList.getWorkoutList()
        XCTAssertNotNil(list[0].getWorkoutDate())
    }
    
}
