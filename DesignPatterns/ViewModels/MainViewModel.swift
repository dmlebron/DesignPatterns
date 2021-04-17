//
//  MainViewModel.swift
//
//  Created by david martinez on 2/24/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import UIKit
import Combine

protocol MainViewModelInput {
    func viewDidAppear()
    func searchTapped(query: String, address: String?)
    func cellTapped(job: Job)
    func updateCurrentLocationTapped()
}

protocol MainViewModelOutput {
    var locationPublisher: AnyPublisher<Location, Never> { get }
    var tableViewDataPublisher: AnyPublisher<MainTableViewViewData, Never>? { get }
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
    private let detailViewController = PassthroughSubject<UIViewController, Never>()
    private let jobs = PassthroughSubject<Jobs, Never>()
    private var searchTappedPub = PassthroughSubject<SearchQuery, Never>()
    
    let locationPublisher: AnyPublisher<Location, Never>
    private(set) var tableViewDataPublisher: AnyPublisher<MainTableViewViewData, Never>?
    let detailViewControllerPublisher: AnyPublisher<UIViewController, Never>
    
    struct SearchQuery: Equatable {
        let query: String
        let address: String?
    }
    
    init(locationService: LocationServiceType, apiClient: ApiClientType, color: Color, imageLoader: ImageLoading) {
        self.locationService = locationService
        self.apiClient = apiClient
        self.color = color
        self.imageLoader = imageLoader
        
        locationPublisher = locationService
            .locationPublisher
            .eraseToAnyPublisher()
        
        detailViewControllerPublisher = detailViewController
            .eraseToAnyPublisher()
        
        tableViewDataPublisher = searchTappedPub
            .flatMap { searchQuery -> AnyPublisher<SearchQuery, Never> in
                self.locationService.updateLocation(address: searchQuery.address)
                return Just(searchQuery)
                    .eraseToAnyPublisher()
            }
            .zip(locationPublisher)
            .flatMap { result -> AnyPublisher<Jobs, Never>  in
                self.fetchJobs(query: result.0.query, city: result.1.city)
            }
            .map { jobs in
                MainTableViewViewData(numberOfSections: Constants.TableView.numberOfSections, numberOfRows: jobs.count, items: jobs)
            }
            .eraseToAnyPublisher()
        
//        tableViewDataPublisher = searchTappedPub
//            .flatMap { searchQuery in
//                self.locationService
//                    .updateLocationForAddress(searchQuery.address)
//                    .map { location in
//                        (searchQuery, location)
//                    }
//            }
//            .flatMap { result -> AnyPublisher<Jobs, Never>  in
//                self.fetchJobs(query: result.0.query, city: result.1.city)
//            }
//            .map { jobs in
//                MainTableViewViewData(numberOfSections: Constants.TableView.numberOfSections, numberOfRows: jobs.count, items: jobs)
//            }
//            .eraseToAnyPublisher()
    }
}

// MARK: - MainViewModelType

extension MainViewModel: MainViewModelType {
    var input: MainViewModelInput { return self }
    var output: MainViewModelOutput { return self }
}

// MARK: - Private

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
        locationService.updateCurrentAddress()
    }
}

// MARK: - MainViewModelOutput

extension MainViewModel: MainViewModelOutput {
    func showAlert(error: Error) {

    }

    func pushViewController(_ viewController: UIViewController) {

    }
}

// MARK: - MainViewModelInput

extension MainViewModel: MainViewModelInput {
    func viewDidAppear() {
        updateCurrentAddress()
    }
    
    func searchTapped(query: String, address: String?) {
        let searchQuery = SearchQuery(query: query, address: address)
        searchTappedPub.send(searchQuery)
    }
    
    func cellTapped(job: Job) {
        let detailViewController = ModuleBuilder().detail(job: job, imageLoader: imageLoader, color: color)
        self.detailViewController.send(detailViewController)
    }
    
    func updateCurrentLocationTapped() {
        updateCurrentAddress()
    }
}
