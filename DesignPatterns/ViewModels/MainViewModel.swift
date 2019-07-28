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
    func cellTapped(job: Job)
    func updateCurrentLocationTapped()
}

protocol MainViewModelOutput: AnyObject {
    var locationPublisher: AnyPublisher<Location?, Never> { get }
    var tableViewDataPublisher: AnyPublisher<TableViewViewData, Never> { get }
    var detailViewControllerPublisher: AnyPublisher<UIViewController, Never> { get }
//    func showAlert(error: Error)
//    func pushViewController(_ viewController: UIViewController)
}

protocol MainViewModelType {
    var input: MainViewModelInput { get }
    var output: MainViewModelOutput { get }
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
    
    init(locationService: LocationServiceType, apiClient: ApiClientType, color: Color, imageLoader: ImageLoading) {
        self.locationService = locationService
        self.apiClient = apiClient
        self.color = color
        self.imageLoader = imageLoader
        
        locationPublisher = location
            .removeDuplicates()
            .eraseToAnyPublisher()
        
        tableViewDataPublisher = jobs
            .map { TableViewViewData(numberOfSections: Constants.TableView.numberOfSections, numberOfRows: $0.count, items: $0) }
            .removeDuplicates()
            .eraseToAnyPublisher()
        
        detailViewControllerPublisher = detailViewController
            .eraseToAnyPublisher()
    }
    
    private let jobs = PassthroughSubject<Jobs, Never>()
//    let jobsPublisher: AnyPublisher<Jobs, Never>
    
    private let location = PassthroughSubject<Location?, Never>()
    let locationPublisher: AnyPublisher<Location?, Never>
    
    let tableViewDataPublisher: AnyPublisher<TableViewViewData, Never>
    
    private let detailViewController =  PassthroughSubject<UIViewController, Never>()
    let detailViewControllerPublisher: AnyPublisher<UIViewController, Never>
}

extension MainViewModel: MainViewModelType {
    var input: MainViewModelInput { return self }
    var output: MainViewModelOutput { return self }
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
                
            case .failed(let error):
                break
//                self.output?.showAlert(error: error)
            }
        }
    }
    
    func updateCurrentAddress() {
        locationService.currentAddress { [weak self] (location) in
            self?.location.send(location)
        }
    }
    
    func searchAddress(address: String, completion: @escaping (Location?) -> Void) {
        locationService.locationFor(address: address) { [weak self] (location) in
            // TODO: Update. This can be improve!
            self?.location.send(location)
            completion(location)
        }
    }
}

// MARK: - MainViewModelOutput
extension MainViewModel: MainViewModelOutput {
    
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
    
    func cellTapped(job: Job) {
        let detailViewController = ModuleBuilder().detail(job: job, imageLoader: imageLoader, color: color)
        self.detailViewController.send(detailViewController)
    }
    
    func updateCurrentLocationTapped() {
        updateCurrentAddress()
    }
    
    func numberOfSections() -> Int {
        return Constants.TableView.numberOfSections
    }
    
    func numberOfRows() -> Int {
        return 0//jobs.
    }
    
    func jobAtIndexPath(_ indexPath: IndexPath) -> Job? {
//        guard jobs.count > indexPath.row else {
            return nil
//        }
//        return jobs[indexPath.row]
    }
}
