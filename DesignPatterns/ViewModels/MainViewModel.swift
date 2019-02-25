//
//  MainViewModel.swift
//
//  Created by david martinez on 2/24/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import Foundation

protocol MainViewModelInput: AnyObject {
    func viewDidAppear()
    func searchTapped(query: String, location: String?)
    func updateCurrentLocationTapped()
    func numberOfSections() -> Int
    func numberOfRows() -> Int
    func jobAtIndexPath(_ indexPath: IndexPath) -> Job?
}

protocol MainViewModelOutput: AnyObject {
    func reloadTableView()
    func userLocationChanged(_ userLocation: UserLocation)
    func showAlert(error: Error)
}

final class MainViewModel {
    private var userLocation: UserLocation?
    private(set) var jobs: Jobs = []
    private weak var output: MainViewModelOutput?
    
    init(output: MainViewModelOutput?) {
        self.output = output
    }
}

// MARK: - Private Methods
private extension MainViewModel {
    func fetchJobs(query: String) {
        let route = userLocation != nil ? Route.parameters([.jobType: query, .location: userLocation!.city]) : Route.parameters([Parameter.jobType: query])
        guard let url = URL(string: route.completeUrl) else { return }
        CurrentEnvironment.apiClient.get(url: url) { [unowned self] result in
            switch result {
            case .success(let jobs):
                self.jobs = jobs
                self.output?.reloadTableView()
                
            case .failed(let error):
                self.output?.showAlert(error: error)
            }
        }
    }
    
    @objc func updateCurrentAddress() {
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

// MARK: - MainViewModelInput
extension MainViewModel: MainViewModelInput {
    func viewDidAppear() {
        updateCurrentAddress()
    }
    
    func searchTapped(query: String, location: String?) {
        if let location = location {
            updateAddressFor(location: location) { [weak self] in
                self?.fetchJobs(query: query)
            }
        } else {
            self.fetchJobs(query: query)
        }
    }
    
    func updateCurrentLocationTapped() {
        updateCurrentAddress()
    }
    
    func cellTappedAtIndexPath(_ indexPath: IndexPath) {
        
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRows() -> Int {
        return jobs.count
    }
    
    func jobAtIndexPath(_ indexPath: IndexPath) -> Job? {
        guard jobs.count > indexPath.row else {
            return nil
        }
        return jobs[indexPath.row]
    }
}
