//
//  Environment.swift
//  DesignPatterns
//
//  Created by david martinez on 2/23/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import UIKit

struct Environment {
    let apiURLSring: String
    let apiClient: ApiClientType
    let locationService: LocationServiceType
    let color: Color
    let imageLoader: ImageLoading
    
    init(apiURLSring: String,
         apiClient: ApiClientType,
         locationService: LocationServiceType,
         color: Color,
         imageLoader: ImageLoading = ImageLoader(imageCache: ImageCache())) {
        
        self.apiURLSring = apiURLSring
        self.apiClient = apiClient
        self.locationService = locationService
        self.color = color
        self.imageLoader = imageLoader
    }
    
    static let development = Environment(apiURLSring: "https://jobs.github.com/positions.json",
                                         apiClient: ApiClient(),
                                         locationService: LocationService(),
                                         color: Color(),
                                         imageLoader: ImageLoader(imageCache: ImageCache()))
}
