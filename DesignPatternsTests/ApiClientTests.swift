//
//  ApiClientTests.swift
//  DesignPatternsTests
//
//  Created by David Martinez-Lebron on 10/21/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import XCTest
@testable import DesignPatterns

class ApiClientTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func test_Route_CompleteURL_No_Parameter() {
        let route = Route.none
        
        XCTAssertEqual(route.completeUrl, "https://jobs.github.com/positions.json")
    }
    
    func test_Route_CompleteURL_JobType_Parameter() {
        let jobType = "iOS"
        let route = Route.parameters([.jobType: jobType])
        
        XCTAssertEqual(route.completeUrl, "https://jobs.github.com/positions.json?description=\(jobType)&")
    }
    
    func test_Route_CompleteURL_Location_Parameter() {
        let location = "boston"
        let route = Route.parameters([.location: location])
        
        XCTAssertEqual(route.completeUrl, "https://jobs.github.com/positions.json?location=\(location)&")
    }
    
    func test_Route_CompleteURL_Location_And_JobType_Parameter() {
        let location = "boston"
        let jobType = "iOS"
        let route = Route.parameters([.location: location, .jobType: jobType])
        
        XCTAssertEqual(route.completeUrl, "https://jobs.github.com/positions.json?location=\(location)&description=\(jobType)&")
    }

}
