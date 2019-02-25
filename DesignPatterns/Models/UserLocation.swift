//
//  Location.swift
//
//  Created by david martinez on 2/24/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import Foundation

struct UserLocation {
    let postalCode: String
    let city: String
    let country: String
    
    var parsed: String {
        return "\(city), \(country)"
    }
}
