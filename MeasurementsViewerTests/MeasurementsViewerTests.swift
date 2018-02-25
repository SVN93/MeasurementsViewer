//
//  MeasurementsViewerTests.swift
//  MeasurementsViewerTests
//
//  Created by Vladislav Solovyov on 14/02/2018.
//  Copyright © 2018 Vladislav Solovyov. All rights reserved.
//

import XCTest
@testable import MeasurementsViewer

class MeasurementsViewerTests: XCTestCase {
    
    let measurementsContainerJSON: Dictionary<String, Any> = {
        var dictionary = Dictionary<String, Any>()
        dictionary["_id"] = "Some ID"
        dictionary["name"] = "Test Name"
        return dictionary
    }()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        
        let measurementsContainer = MeasurementsContainer(self.measurementsContainerJSON)
        XCTAssert(measurementsContainer.name == "Test Name", "Name was correctly mapped")
        XCTAssert(measurementsContainer.id == "Some ID", "Id was correctly mapped")
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
