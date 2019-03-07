//
//  MainPresenter.swift
//  DesignPatterns
//
//  Created by David Martinez-Lebron on 2/25/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import UIKit

// MARK: - Constants
private extension MainPresenter {
    enum Constants {
        enum TableView {
            static var numberOfSections: Int { return 1 }
        }
    }
}

final class MainPresenter {
    private typealias ViewDataType = MainViewController.ViewDataType
    private let interactor: MainInteractorInput
    private let router: MainRouterInput
    private var userLocation: Location?
    private weak var view: MainViewInput?
    
    init(interactor: MainInteractorInput, router: MainRouterInput) {
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - MainViewOutput
extension MainPresenter: MainViewOutput {
    func set(view: MainViewInput) {
        self.view = view
    }
    
    func viewDidAppear() {
        interactor.updateCurrentAddress()
    }
    
    func searchTapped(query: String, location: String?) {
        interactor.searchTapped(query: query, zipcode: location)
    }
    
    func updateCurrentLocationTapped() {
        interactor.updateCurrentAddress()
    }
    
    func cellTapped(job: Job?, navigationController: UINavigationController?) {
        guard let navigationController = navigationController, let job = job else { return }
        router.navigateToDetailViewController(job: job, userLocation: userLocation, context: navigationController)
    }
}

// MARK: - MainInteractorOutput
extension MainPresenter: MainInteractorOutput {
    func changed(location: Location?) {
        view?.changed(viewDataType: ViewDataType.location(location))
    }
    
    func changed(userLocation: Location?) {
        self.userLocation = userLocation
        changed(location: self.userLocation)
    }
    
    func changed(jobs: Jobs) {
        prepareTableViewData(jobs: jobs)
    }
    
    func failed(error: Error) {
        view?.showAlert(error: error)
    }
}

// MARK: - Private Methods
private extension MainPresenter {
    func prepareTableViewData(jobs: Jobs) {
        var items: [IndexPath: Job] = [:]
        
        for (index, job) in jobs.enumerated() {
            items[IndexPath(row: index, section: 0)] = job
        }
        
        let tableViewData = MainViewController.TableViewViewData(numberOfSections: Constants.TableView.numberOfSections, numberOfRows: jobs.count, items: items)
        view?.changed(viewDataType: ViewDataType.tableViewData(tableViewData))
    }
}
