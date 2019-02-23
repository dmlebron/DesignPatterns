//
//  Environment.swift
//  DesignPatterns
//
//  Created by david martinez on 2/23/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import Foundation

struct Environment {
    let apiURLSring: String
    let apiClient: ApiClientType
    let locationService: LocationServiceType
    let color: Color
    
    init(apiURLSring: String,
         apiClient: ApiClientType,
         locationService: LocationServiceType,
         color: Color) {
        
        self.apiURLSring = apiURLSring
        self.apiClient = apiClient
        self.locationService = locationService
        self.color = color
    }
    
    static let development = Environment(apiURLSring: "https://jobs.github.com/positions.json",
                                         apiClient: ApiClient(),
                                         locationService: LocationService(),
                                         color: Color())
}

extension Environment {
    static let mock = Environment(apiURLSring: "https://jobs.github.com/positions.json",
                                  apiClient: MockApiClient(),
                                  locationService: MockLocationService(),
                                  color: Color())
}
