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
    var didCallRequestWhenInUseAuthorization = false
    func requestWhenInUseAuthorization() {
        didCallRequestWhenInUseAuthorization = true
    }
    
    var didCallCurrentAdrress = false
    var expectedCurrentAddressPlaceMark: MKPlacemark?
    func currentAddress(completion: @escaping (MKPlacemark?) -> ()) {
        didCallCurrentAdrress = true
        completion(expectedCurrentAddressPlaceMark)
    }
    
    var didCallAddressForPostalCode = false
    var expectedAddressForPostalCodePlaceMark: MKPlacemark?
    func addressFor(location: String, completion: @escaping (MKPlacemark?) -> ()) {
        didCallAddressForPostalCode = true
        completion(expectedAddressForPostalCodePlaceMark)
    }
}
