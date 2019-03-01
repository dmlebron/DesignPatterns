//
//  Location.swift
//
//  Created by david martinez on 2/24/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import Foundation

struct UserLocation {
    
    enum Error: Swift.Error {
        case invalidPostalCodeLength
        case invalidPostalCodeFormat
        case invalidCountryLength
        
        var localizedDescription: String {
            switch self {
            case .invalidPostalCodeLength:
                return "Postal code should have 5 characters (i.e. 04341)"
            case .invalidPostalCodeFormat:
                return "Postal code should only contain numeric characters (i.e. 04341)"
            case .invalidCountryLength:
                return "Country should be have 2 characters (i.e. MA)"
            }
        }
    }
    
    let postalCode: String
    let city: String
    let country: String
    
    init(postalCode: String, city: String, country: String) throws {
        self.postalCode = postalCode
        self.city = city.capitalized
        self.country = country.uppercased()
        try validate()
    }
    
    var parsed: String {
        return "\(city), \(country) \(postalCode)"
    }
}

private extension UserLocation {
    func validate() throws {
        if postalCode.count != 5 {
            throw Error.invalidPostalCodeLength
        }
        
        guard let _ = Int(postalCode) else {
            throw Error.invalidPostalCodeFormat
        }
        
        if country.count != 2 {
            throw Error.invalidCountryLength
        }
    }
}
