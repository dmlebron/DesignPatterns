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
import Combine

protocol LocationServiceType {
    var locationPublisher: AnyPublisher<Location, Never> { get }
    
    func updateCurrentAddress()
    
    func requestWhenInUseAuthorization()
//    func currentAddress(completion: @escaping (Location?) -> ())
//    func locationFor(address: String, completion: @escaping (Location?) -> ())
//
//    func locationFor(address: String?) -> Future<Location?, Error>
//    func updateLocationForAddress(_ address: String?) -> AnyPublisher<Location, Never>
    func updateLocation(address: String?)
}

final class LocationService {
    private let locationManager = CLLocationManager()
    private let geo = CLGeocoder()
    private let region = CLRegion()
    private let location = PassthroughSubject<Location, Never>()
    
    let locationPublisher: AnyPublisher<Location, Never>
    
    init() {
        locationManager.startUpdatingLocation()
        
        locationPublisher = location
            .eraseToAnyPublisher()
    }
}

// MARK: - LocationServiceType
extension LocationService: LocationServiceType {
    func updateCurrentAddress() {
        guard let location = locationManager.location else { return }

        geo.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            guard let city = placemarks?.first?.locality,
                let country = placemarks?.first?.isoCountryCode,
                let userLocation = try? Location(city: city, country: country, postalCode: placemarks?.first?.postalCode) else {
                    return
            }
            
            self?.location.send(userLocation)
        }
    }
    
    func currentAddress(completion: @escaping (Location?) -> ()) {
        guard let location = locationManager.location else { return completion(nil) }

        geo.reverseGeocodeLocation(location) { (placemarks, error) in
            guard let city = placemarks?.first?.locality,
                let country = placemarks?.first?.isoCountryCode,
                let userLocation = try? Location(city: city, country: country, postalCode: placemarks?.first?.postalCode) else {
                    return completion(nil)
            }
            completion(userLocation)
        }
    }
    
    func locationFor(address: String, completion: @escaping (Location?) -> ()) {
        geo.geocodeAddressString(address) { (placemarks, error) in
            guard let city = placemarks?.first?.locality,
                let country = placemarks?.first?.isoCountryCode,
                let userLocation = try? Location(city: city, country: country, postalCode: placemarks?.first?.postalCode) else {
                    return completion(nil)
            }
            completion(userLocation)
        }
    }
    
    func updateLocationForAddress(_ address: String?) -> AnyPublisher<Location, Never> {
        let future = Future<Location, Never> { futureResult in
            self.geo.geocodeAddressString(address ?? "") { [weak self] (placemarks, error) in
                let location: Location
                
                if let city = placemarks?.first?.locality,
                    let country = placemarks?.first?.isoCountryCode,
                    let userLocation = try? Location(city: city, country: country, postalCode: placemarks?.first?.postalCode) {
                    
                    location = userLocation
                    
                } else {
                    location = Location(city: "", country: "")
                }
                
                futureResult(.success(location))
                self?.location.send(location)
            }
        }
        return future.eraseToAnyPublisher()
    }
    
    func updateLocation(address: String?) {
        self.geo.geocodeAddressString(address ?? "") { [weak self] (placemarks, error) in
            let location: Location
            
            if let city = placemarks?.first?.locality,
                let country = placemarks?.first?.isoCountryCode,
                let userLocation = try? Location(city: city, country: country, postalCode: placemarks?.first?.postalCode) {
                
                location = userLocation
                
            } else {
                location = Location(city: "", country: "")
            }
            
            self?.location.send(location)
        }
    }
    
    func locationFor(address: String?) -> Future<Location?, Error> {
        let future = Future<Location?, Error> { futureResult in
            guard
                let address = address
                else {
                    futureResult(.success(nil))
                    return
                }
            self.geo.geocodeAddressString(address) { (placemarks, error) in
                let result: Result<Location?, Error>
                
                if let error = error {
                    result = .failure(error)
                    
                } else if let city = placemarks?.first?.locality,
                    let country = placemarks?.first?.isoCountryCode {
                    let userLocation = try? Location(city: city, country: country, postalCode: placemarks?.first?.postalCode)
                    result = .success(userLocation)
                    
                } else {
                    result = .success(nil)
                }
                
                futureResult(result)
            }
        }
        return future
    }
    
    func requestWhenInUseAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
}
