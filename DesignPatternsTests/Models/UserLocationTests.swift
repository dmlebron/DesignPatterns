//
//  UserLocationTests.swift
//  DesignPatternsTests
//
//  Created by david martinez on 2/28/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import XCTest
@testable import DesignPatterns

final class UserLocationTests: XCTestCase {
    var userLocation: UserLocation!
    
    func test_Init_NoThrow_CorrectFormat() throws {
        XCTAssertNoThrow(try UserLocation(postalCode: "02130", city: "boston", country: "MA"))
    }
    
    func test_Init_Throws_IncorrectCountryLength() throws {
        XCTAssertThrowsError(try UserLocation(postalCode: "02130", city: "boston", country: "South Carolina"))
    }
    
    func test_Init_Throws_IncorrectPostalCodeLength() throws {
        XCTAssertThrowsError(try UserLocation(postalCode: "0213", city: "boston", country: "MA"))
    }
    
    func test_Init_Throws_IncorrectPostalCodeFormat() throws {
        XCTAssertThrowsError(try UserLocation(postalCode: "0213a", city: "boston", country: "MA"))
    }
    
    func test_Parsed_NoThrow_CorrectFormat() throws {
        userLocation = try UserLocation(postalCode: "02130", city: "boston", country: "ma")
        let parsed = userLocation.parsed
        XCTAssertTrue(parsed == "Boston, MA 02130")
    }
}
