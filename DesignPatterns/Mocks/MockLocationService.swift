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
    var expectedUserLocation: UserLocation?
    
    var didCallRequestWhenInUseAuthorization = false
    func requestWhenInUseAuthorization() {
        didCallRequestWhenInUseAuthorization = true
    }
    
    var didCallCurrentAdrress = false
    func currentAddress(completion: @escaping (UserLocation?) -> ()) {
        didCallCurrentAdrress = true
        completion(expectedUserLocation)
    }
    
    var didCallAddressForPostalCode = false
    func addressFor(location: String, completion: @escaping (UserLocation?) -> ()) {
        didCallAddressForPostalCode = true
        completion(expectedUserLocation)
    }
}
