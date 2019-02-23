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
    func currentAddress(completion: @escaping (MKPlacemark?) -> ())
    func addressFor(postalCode: String, completion: @escaping (MKPlacemark?) -> ())
}

final class LocationService: LocationServiceType {
    private let locationManager = CLLocationManager()
    private let geo = CLGeocoder()
    private let region = CLRegion()
    
    init() {
        locationManager.startUpdatingLocation()
    }
    
    func currentAddress(completion: @escaping (MKPlacemark?) -> ()) {
        guard let location = locationManager.location else { return }
        
        geo.reverseGeocodeLocation(location) { (placemarks, error) in
            guard let location = placemarks?.first?.location, let postalAddress = placemarks?.first?.postalAddress else {
                return completion(nil)
            }
            
            let mkPlacemark = MKPlacemark(coordinate: location.coordinate, postalAddress: postalAddress)
            completion(mkPlacemark)
        }
    }
    
    func addressFor(postalCode: String, completion: @escaping (MKPlacemark?) -> ()) {
        geo.geocodeAddressString(postalCode) { (placemarks, error) in
            guard let location = placemarks?.first?.location, let postalAddress = placemarks?.first?.postalAddress else {
                return completion(nil)
            }
            
            let mkPlacemark = MKPlacemark(coordinate: location.coordinate, postalAddress: postalAddress)
            completion(mkPlacemark)
        }
    }
    
    func requestWhenInUseAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
}











