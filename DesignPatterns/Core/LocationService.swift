//
//  LocationService.swift
//
//  Created by David Martinez-Lebron on 1/12/18.
//  Copyright © 2018 David Martinez-Lebron. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit
import Contacts

protocol LocationServiceType {
    func requestWhenInUseAuthorization()
    func currentAddress(completion: @escaping (Location?) -> ())
    func addressFor(location: String, completion: @escaping (Location?) -> ())
}

final class LocationService {
    private let locationManager = CLLocationManager()
    private let geo = CLGeocoder()
    private let region = CLRegion()
    
    init() {
        locationManager.startUpdatingLocation()
    }
}

// MARK: - LocationServiceType
extension LocationService: LocationServiceType {
    func currentAddress(completion: @escaping (Location?) -> ()) {
        guard let location = locationManager.location else { return completion(nil) }
        
        geo.reverseGeocodeLocation(location) { (placemarks, error) in
            guard let city = placemarks?.first?.locality,
                let postalCode = placemarks?.first?.postalCode,
                let country = placemarks?.first?.isoCountryCode,
                let userLocation = try? Location(postalCode: postalCode, city: city, country: country) else {
                    return completion(nil)
            }
            completion(userLocation)
        }
    }
    
    func addressFor(location: String, completion: @escaping (Location?) -> ()) {
        geo.geocodeAddressString(location) { (placemarks, error) in
            guard let city = placemarks?.first?.locality,
                let postalCode = placemarks?.first?.postalCode,
                let country = placemarks?.first?.isoCountryCode,
                let userLocation = try? Location(postalCode: postalCode, city: city, country: country) else {
                    return completion(nil)
            }
            completion(userLocation)
        }
    }
    
    func requestWhenInUseAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
}
