//
//  MockLocationService.swift
//  DesignPatternsTests
//
//  Created by david martinez on 2/23/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import Foundation
import MapKit
import Combine
@testable import DesignPatterns

class MockLocationService: LocationServiceType {
    var location: AnyPublisher<Location, Error> {
        let f = Future<Location, Error> { result in
            
        }
        return f.eraseToAnyPublisher()
    }
    
    func updateLocationForAddress(_ address: String?) -> AnyPublisher<Location, Never> {
        return Just(Location(city: "", country: "")).eraseToAnyPublisher()
    }
    
    private var stubLocation: Location?
    
    var didCallRequestWhenInUseAuthorization = false
    func requestWhenInUseAuthorization() {
        didCallRequestWhenInUseAuthorization = true
    }
    
    var didCallCurrentAdrress = false
    func currentAddress(completion: @escaping (Location?) -> ()) {
        didCallCurrentAdrress = true
        completion(stubLocation)
    }
    
    var didCallLocationForAddress = false
    func locationFor(address: String, completion: @escaping (Location?) -> ()) {
        didCallLocationForAddress = true
        completion(stubLocation)
    }
    
    func locationFor(address: String?) -> Future<Location?, Error> {
        let future = Future<Location?, Error> { result in
            result(.success(self.stubLocation))
        }
        return future
    }
}

// MARK: - Configuration Helper
extension MockLocationService {
    func configureCompletion(location: Location) {
        stubLocation = location
    }
    
    func reset() {
        stubLocation = nil
        didCallLocationForAddress = false
        didCallRequestWhenInUseAuthorization = false
        didCallCurrentAdrress = false
    }
}
