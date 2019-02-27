//
//  MainInteractor.swift
//  DesignPatterns
//
//  Created by David Martinez-Lebron on 2/25/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import Foundation

protocol MainInteractorInput: AnyObject {
    func set(presenter: MainInteractorOutput)
    func fetchJobs(query: String, location: String?)
    func updateCurrentAddress()
}

protocol MainInteractorOutput: AnyObject {
    func changed(userLocation: UserLocation?)
    func changed(jobs: Jobs)
    func failed(error: Error)
}

final class MainInteractor {
   private weak var presenter: MainInteractorOutput?
}

// MARK: - MainInteractorInput
extension MainInteractor: MainInteractorInput {
    func set(presenter: MainInteractorOutput) {
        self.presenter = presenter
    }
    
    func fetchJobs(query: String, location: String?) {
        if let location = location {
            updateAddressFor(location: location) { [weak self] (userLocation) in
                self?.fetchJobs(query: query, userLocation: userLocation)
            }
        } else {
            self.fetchJobs(query: query)
        }
    }
    
    func updateCurrentAddress() {
        CurrentEnvironment.locationService.currentAddress { [unowned self] (placemark) in
            if let city = placemark?.locality, let postalCode = placemark?.postalCode, let country = placemark?.isoCountryCode {
                let userLocation = UserLocation(postalCode: postalCode, city: city, country: country)
                self.presenter?.changed(userLocation: userLocation)
            }
        }
    }
}

// MARK: - Private Methods
private extension MainInteractor {
    func fetchJobs(query: String, userLocation: UserLocation? = nil) {
        let route = userLocation != nil ? Route.parameters([.jobType: query, .location: userLocation!.city]) : Route.parameters([Parameter.jobType: query])
        guard let url = URL(string: route.completeUrl) else { return }
        CurrentEnvironment.apiClient.get(url: url) { [unowned self] result in
            switch result {
            case .success(let jobs):
                self.presenter?.changed(jobs: jobs)
                
            case .failed(let error):
                self.presenter?.failed(error: error)
            }
        }
    }
    
    func updateAddressFor(location: String, completion: @escaping (UserLocation?) -> Void) {
        CurrentEnvironment.locationService.addressFor(location: location) { (placemark) in
            guard let city = placemark?.locality, let postalCode = placemark?.postalCode, let country = placemark?.isoCountryCode else {
                return completion(nil)
            }
            let userLocation = UserLocation(postalCode: postalCode, city: city, country: country)
            completion(userLocation)
        }
    }
}
