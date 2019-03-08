//
//  MockLocation.swift
//  DesignPatterns
//
//  Created by David Martinez-Lebron on 3/1/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//
import Foundation

struct MockLocation {
    static var boston: Location {
        return try! Location(city: "Boston", country: "MA", postalCode: "02130")
    }

    static var bostonNoZipcode: Location {
        return try! Location(city: "Boston", country: "MA")
    }
}
