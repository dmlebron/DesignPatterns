//
//  MainInteractor.swift
//  DesignPatterns
//
//  Created by David Martinez-Lebron on 2/25/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import Foundation

//MARK: - To be Conformed by MainInteractor
protocol MainInteractorInput: AnyObject {
    func set(presenter: MainInteractorOutput)
    func searchTapped(query: String, address: String?)
    func updateCurrentAddress()
}

//MARK: - To be Conformed by MainPresenter
protocol MainInteractorOutput: AnyObject {
    func changed(location: Location?)
    func changed(userLocation: Location?)
    func changed(jobs: Jobs)
    func failed(error: Error)
}

final class MainInteractor {
    private let locationService: LocationServiceType
    private let apiClient: ApiClientType
    private(set) weak var presenter: MainInteractorOutput?
    
    init(locationService: LocationServiceType, apiClient: ApiClientType) {
        self.locationService = locationService
        self.apiClient = apiClient
    }
}

// MARK: - MainInteractorInput
extension MainInteractor: MainInteractorInput {
    func set(presenter: MainInteractorOutput) {
        self.presenter = presenter
    }
    
    func searchTapped(query: String, address: String?) {
        if let address = address {
            searchAddress(address: address) { [weak self] (location) in
                self?.fetchJobs(query: query, city: location?.city)
            }
        } else {
            self.fetchJobs(query: query)
        }
    }
    
    func updateCurrentAddress() {
        locationService.currentAddress { [unowned self] (location) in
            self.presenter?.changed(userLocation: location)
        }
    }
}

// MARK: - Private Methods
private extension MainInteractor {
    func fetchJobs(query: String, city: String? = nil) {
        let route = city != nil ? Route.parameters([.jobType: query, .location: city!]) : Route.parameters([Parameter.jobType: query])
        guard let url = URL(string: route.completeUrl) else { return }
        apiClient.get(url: url) { [unowned self] result in
            switch result {
            case .success(let jobs):
                self.presenter?.changed(jobs: jobs)
                
            case .failed(let error):
                self.presenter?.failed(error: error)
            }
        }
    }
    
    func searchAddress(address: String, completion: @escaping (Location?) -> Void) {
        locationService.locationFor(address: address) { (searchLocation) in
            completion(searchLocation)
        }
    }
}
