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
    var locationPublisher: AnyPublisher<Location?, Never>? { get set }
    var tableViewDataPublisher: AnyPublisher<TableViewViewData, Never>? { get set }
    var detailViewControllerPublisher: AnyPublisher<UIViewController, Never>? { get set }
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
//    private(set) var userLocation: Location?
    private var subscriptions: [AnyCancellable] = []

    struct SearchQuery: Equatable {
        let query: String
        let zipCode: String?
    }
    
    init(locationService: LocationServiceType, apiClient: ApiClientType, color: Color, imageLoader: ImageLoading) {
        self.locationService = locationService
        self.apiClient = apiClient
        self.color = color
        self.imageLoader = imageLoader
        
        locationPublisher = location
            .removeDuplicates()
            .eraseToAnyPublisher()
        
        // TODO: How to add error query and how to update the location and perform a request after?
        tableViewDataPublisher = searchTappedPub
            .breakpoint()
            .print()
            .flatMap { searchQuery -> Future<SearchQuery, Never> in
                self.searchAddress(query: searchQuery.query, zipCode: searchQuery.zipCode)
            }
            .combineLatest(location)
            .print()
            .flatMap { result -> AnyPublisher<Jobs, Never>  in
                self.fetchJobs(query: result.0.query, city: result.1?.city)
            }
            .print()
            .map { jobs in
                TableViewViewData(numberOfSections: Constants.TableView.numberOfSections, numberOfRows: jobs.count, items: jobs)
            }
            .eraseToAnyPublisher()
        
        detailViewControllerPublisher = detailViewController
            .eraseToAnyPublisher()
    }
    
    private let jobs = PassthroughSubject<Jobs, Never>()
    
    private let location = PassthroughSubject<Location?, Never>()
    var locationPublisher: AnyPublisher<Location?, Never>?
    
    var tableViewDataPublisher: AnyPublisher<TableViewViewData, Never>?
    
    private let detailViewController = PassthroughSubject<UIViewController, Never>()
    var detailViewControllerPublisher: AnyPublisher<UIViewController, Never>?

    private var searchTappedPub = PassthroughSubject<SearchQuery, Never>()
    
}

extension MainViewModel: MainViewModelType {
    var input: MainViewModelInput { return self }
    var output: MainViewModelOutput { return self }
}

// MARK: - Private Methods
private extension MainViewModel {
    func fetchJobs(query: String, city: String? = nil) -> AnyPublisher<Jobs, Never> {
        if query.isEmpty {
//            output?.showAlert(error: Error.invalidQuery)
//            return
        }

        let route = city != nil ? Route.parameters([.jobType: query, .location: city!]) : Route.parameters([Parameter.jobType: query])
        let url = URL(string: route.completeUrl)!

        return apiClient.get(url: url)
            .catch { _ in Just([]) }
            .eraseToAnyPublisher()
    }
    
    func updateCurrentAddress() {
        locationService.currentAddress { [weak self] (location) in
            self?.location.send(location)
        }
    }
    
    func searchAddress(query: String, zipCode: String?) -> Future<SearchQuery, Never> {
        let future = Future<SearchQuery, Never>({ result in
            if let zipCode = zipCode, !zipCode.isEmpty, let _ = Int(zipCode) {
                self.locationService.locationFor(address: zipCode) { [weak self] (location) in
                    self?.location.send(location)
                    result(.success(SearchQuery(query: query, zipCode: zipCode)))
                }
            } else {
                result(.success(SearchQuery(query: query, zipCode: nil)))
            }
        })

        return future
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
        let searchQuery = SearchQuery(query: query, zipCode: address)
//        searchQueryPub.send(searchQuery)
//        searchAddress(zipCode: address)
//        fetchJobs(query: query)
        searchTappedPub.send(searchQuery)
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
