//
//  MockUserLocation.swift
//  DesignPatterns
//
//  Created by David Martinez-Lebron on 3/1/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import Foundation

struct MockUserLocation {
    static var boston: UserLocation {
        return try! UserLocation(postalCode: "02130", city: "Boston", country: "MA")
    }
}
