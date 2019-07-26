//
//  MainViewModel.swift
//
//  Created by david martinez on 2/24/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import UIKit
import Combine

protocol MainViewModelInput: AnyObject {
    func viewDidAppear()
    func searchTapped(query: String, address: String?)
    func cellTappedAtIndexPath(_ indexPath: IndexPath)
    func updateCurrentLocationTapped()
    func numberOfSections() -> Int
    func numberOfRows() -> Int
    func jobAtIndexPath(_ indexPath: IndexPath) -> Job?
}

protocol MainViewModelOutput: AnyObject {
    var jobsPublisher: AnyPublisher<Jobs, Never> { get }
    var locationPublisher: AnyPublisher<Location, Never> { get }
//    func set(viewModel: MainViewModelInput)
//    func reloadTableView()
//    func locationChanged(_ location: Location?)
//    func showAlert(error: Error)
//    func pushViewController(_ viewController: UIViewController)
}

// MARK: - Constants
private extension MainViewModel {
    enum Constants {
        enum TableView {
            static var numberOfSections: Int { return 1 }
        }
    }
}

final class MainViewModel {
    enum Error: Swift.Error {
        case invalidQuery

        var localizedDescription: String {
            switch self {
            case .invalidQuery:
                return "Invalid Query"
            }
        }
    }
    
    private let color: Color
    private let locationService: LocationServiceType
    private let apiClient: ApiClientType
    private let imageLoader: ImageLoading
    private(set) var userLocation: Location?
//    private(set) var jobs: Jobs = []
    var output: MainViewModelOutput {
        return self
    }
    
    init(locationService: LocationServiceType, apiClient: ApiClientType, color: Color, imageLoader: ImageLoading) {
        self.locationService = locationService
        self.apiClient = apiClient
        self.color = color
        self.imageLoader = imageLoader
        jobsPublisher = jobs.eraseToAnyPublisher()
    }
    
    private let jobs = PassthroughSubject<Jobs, Never>()
    let jobsPublisher: AnyPublisher<Jobs, Never>
    
    private let location = PassthroughSubject<Location, Never>()
    let locationPublisher = AnyPublisher<Location, Never>()
}

extension MainViewModel: MainViewModelOutput {
    
}

// MARK: - Private Methods
private extension MainViewModel {
    func fetchJobs(query: String, city: String? = nil) {
        if query.isEmpty {
//            output?.showAlert(error: Error.invalidQuery)
            return
        }

        let route = city != nil ? Route.parameters([.jobType: query, .location: city!]) : Route.parameters([Parameter.jobType: query])
        guard let url = URL(string: route.completeUrl) else { return }
        apiClient.get(url: url) { [unowned self] result in
            switch result {
            case .success(let jobs):
                self.jobs.send(jobs)
                break
//                self.output?.reloadTableView()
                
            case .failed(let error):
                break
//                self.output?.showAlert(error: error)
            }
        }
    }
    
    func updateCurrentAddress() {
        locationService.currentAddress { [unowned self] (location) in
            self.userLocation = location
//            self.output?.locationChanged(location)
        }
    }
    
    func searchAddress(address: String, completion: @escaping (Location?) -> Void) {
        locationService.locationFor(address: address) { [unowned self] (location) in
//           self.output?.locationChanged(location)
            completion(location)
        }
    }
}

// MARK: - MainViewModelInput
extension MainViewModel: MainViewModelInput {
    func viewDidAppear() {
        updateCurrentAddress()
    }
    
    func searchTapped(query: String, address: String?) {
        if let address = address, !address.isEmpty {
            searchAddress(address: address) { [weak self] (location) in
                self?.fetchJobs(query: query, city: location?.city)
            }
        } else {
            self.fetchJobs(query: query)
        }
    }
    
    func cellTappedAtIndexPath(_ indexPath: IndexPath) {
        guard let job = jobAtIndexPath(indexPath) else { return }
        let detailViewController = ModuleBuilder().detail(job: job, imageLoader: imageLoader, color: color)
//        output?.pushViewController(detailViewController)
    }
    
    func updateCurrentLocationTapped() {
        updateCurrentAddress()
    }
    
    func numberOfSections() -> Int {
        return 0//Constants.TableView.numberOfSections
    }
    
    func numberOfRows() -> Int {
        return 0//jobs.count
    }
    
    func jobAtIndexPath(_ indexPath: IndexPath) -> Job? {
//        guard jobs.count > indexPath.row else {
            return nil
//        }
//        return jobs[indexPath.row]
    }
}
