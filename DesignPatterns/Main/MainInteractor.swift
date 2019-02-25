//
//  MainInteractor.swift
//  DesignPatterns
//
//  Created by David Martinez-Lebron on 2/25/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import Foundation

protocol MainInteractorInput: AnyObject {
    func fetchJobs(query: String)
    func updateCurrentAddress()
}

protocol MainInteractorOutput: AnyObject {
    func userLocationChanged(_ userLocation: UserLocation?)
    func changed(jobs: Jobs)
    func failed(error: Error)
}

final class MainInteractor {
    private var userLocation: UserLocation? {
        didSet {
            output?.userLocationChanged(userLocation)
        }
    }
    private(set) var jobs: Jobs = []
    weak var output: MainInteractorOutput?
}

extension MainInteractor: MainInteractorInput {
    func fetchJobs(query: String) {
        let route = userLocation != nil ? Route.parameters([.jobType: query, .location: userLocation!.city]) : Route.parameters([Parameter.jobType: query])
        guard let url = URL(string: route.completeUrl) else { return }
        CurrentEnvironment.apiClient.get(url: url) { [unowned self] result in
            switch result {
            case .success(let jobs):
                self.jobs = jobs
                self.output?.changed(jobs: jobs)
                
            case .failed(let error):
                self.output?.failed(error: error)
            }
        }
    }
    
    func updateCurrentAddress() {
        CurrentEnvironment.locationService.currentAddress { [unowned self] (placemark) in
            if let city = placemark?.locality, let postalCode = placemark?.postalCode, let country = placemark?.isoCountryCode {
                self.userLocation = UserLocation(postalCode: postalCode, city: city, country: country)
            }
        }
    }
    
    func updateAddressFor(location: String, completion: @escaping () -> Void) {
        CurrentEnvironment.locationService.addressFor(location: location) { [unowned self] (placemark) in
            guard let city = placemark?.locality, let postalCode = placemark?.postalCode, let country = placemark?.isoCountryCode else {
                return completion()
            }
            self.userLocation = UserLocation(postalCode: postalCode, city: city, country: country)
            completion()
        }
    }
}
