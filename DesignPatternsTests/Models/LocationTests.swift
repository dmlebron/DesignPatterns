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
        XCTAssertNoThrow(try Location(city: "boston", country: "MA", postalCode: "02130"))
    }
    
    func test_Init_Throws_IncorrectCountryLength() throws {
        XCTAssertThrowsError(try Location(city: "boston", country: "South Carolina", postalCode: "02130"))
    }
    
    func test_Init_Throws_IncorrectPostalCodeLength() throws {
        XCTAssertThrowsError(try Location(city: "boston", country: "MA", postalCode: "0"))
    }
    
    func test_Parsed_NoThrow_CorrectFormat() throws {
        location = try Location(city: "boston", country: "ma", postalCode: "02130")
        let parsed = location.parsed
        XCTAssertTrue(parsed == "Boston, MA 02130")
    }

    func test_Parsed_NoThrow_CorrectFormat_NoPostalCode() throws {
        location = try Location(city: "boston", country: "ma")
        let parsed = location.parsed
        XCTAssertTrue(parsed == "Boston, MA No Postal Code")
    }
}
