//
//  LocationTests.swift
//  DesignPatternsTests
//
//  Created by david martinez on 2/28/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import XCTest
@testable import DesignPatterns

final class UserLocationTests: XCTestCase {
    var location: Location!
    
    func test_Init_NoThrow_CorrectFormat() throws {
        XCTAssertNoThrow(try Location(postalCode: "02130", city: "boston", country: "MA"))
    }
    
    func test_Init_Throws_IncorrectCountryLength() throws {
        XCTAssertThrowsError(try Location(postalCode: "02130", city: "boston", country: "South Carolina"))
    }
    
    func test_Init_Throws_IncorrectPostalCodeLength() throws {
        XCTAssertThrowsError(try Location(postalCode: "0", city: "boston", country: "MA"))
    }
    
    func test_Parsed_NoThrow_CorrectFormat() throws {
        location = try Location(postalCode: "02130", city: "boston", country: "ma")
        let parsed = location.parsed
        XCTAssertTrue(parsed == "Boston, MA 02130")
    }
}
