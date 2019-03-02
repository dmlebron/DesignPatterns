//
//  MockLocationService.swift
//  DesignPatternsTests
//
//  Created by david martinez on 2/23/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import Foundation
import MapKit

class MockLocationService: LocationServiceType {
    private var expectedUserLocation: Location?
    
    var didCallRequestWhenInUseAuthorization = false
    func requestWhenInUseAuthorization() {
        didCallRequestWhenInUseAuthorization = true
    }
    
    var didCallCurrentAdrress = false
    func currentAddress(completion: @escaping (Location?) -> ()) {
        didCallCurrentAdrress = true
        completion(expectedUserLocation)
    }
    
    var didCallAddressForPostalCode = false
    func addressFor(location: String, completion: @escaping (Location?) -> ()) {
        didCallAddressForPostalCode = true
        completion(expectedUserLocation)
    }
}

// MARK: - Configuration Helper
extension MockLocationService {
    func configureCompletion(location: Location) {
        expectedUserLocation = location
    }
}
