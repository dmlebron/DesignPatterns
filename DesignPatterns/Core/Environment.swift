//
//  Environment.swift
//  DesignPatterns
//
//  Created by david martinez on 2/23/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import Foundation

// MARK: - Constants
fileprivate struct Constants {
    struct Production {
        static var apiURLString: String { return "https://jobs.github.com/positions.json" }
    }
    
    struct Development {
        static var apiURLString: String { return "https://jobs.github.com/positions.json" }
    }
}

struct Environment {
    
    let apiURLSring: String
    let apiClient: ApiClientType
    let locationService: LocationServiceType
    
    init(apiURLSring: String,
         apiClient: ApiClientType,
         locationService: LocationServiceType) {
        
        self.apiURLSring = apiURLSring
        self.apiClient = apiClient
        self.locationService = locationService
    }
    
    static let production = Environment(apiURLSring: Constants.Production.apiURLString,
                                        apiClient: ApiClient(),
                                        locationService: LocationService())
    
    static let development = Environment(apiURLSring: Constants.Development.apiURLString,
                                         apiClient: ApiClient(),
                                         locationService: LocationService())
}
