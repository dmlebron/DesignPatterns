//
//  Location.swift
//
//  Created by david martinez on 2/24/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import Foundation

struct Location {
    enum Error: Swift.Error {
        case invalidPostalCodeLength
        case invalidCountryLength
        
        var localizedDescription: String {
            switch self {
            case .invalidPostalCodeLength:
                return "Postal code should have 2 characters or more"
            case .invalidCountryLength:
                return "Country should be have 2 characters (i.e. MA)"
            }
        }
    }
    
    let city: String
    let country: String
    let postalCode: String?
    
    init(city: String, country: String, postalCode: String?) throws {
        self.city = city.capitalized
        self.country = country.uppercased()
        self.postalCode = postalCode
        try validate()
    }
    
    init(city: String, country: String) {
        self.city = city.capitalized
        self.country = country.uppercased()
        self.postalCode = nil
    }
    
    var parsed: String {
        guard !city.isEmpty, !country.isEmpty else { return "" }
        return "\(city), \(country)"
    }
}

private extension Location {
    func validate() throws {
        if let postalCode = postalCode, postalCode.count < 2 {
            throw Error.invalidPostalCodeLength
        }

        if country.count != 2 {
            throw Error.invalidCountryLength
        }
    }
}

extension Location: Equatable {
    //no op
}
