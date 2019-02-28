//
//  MainPresenter.swift
//  DesignPatterns
//
//  Created by David Martinez-Lebron on 2/25/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import UIKit

final class MainPresenter {
    private typealias ViewDataType = MainViewController.ViewDataType
    private let interactor: MainInteractorInput
    private let router: MainRouterInput
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
        interactor.fetchJobs(query: query, location: location)
    }
    
    func updateCurrentLocationTapped() {
        interactor.updateCurrentAddress()
    }
    
    func cellTapped(job: Job?, navigationController: UINavigationController?) {
        guard let navigationController = navigationController, let job = job else { return }
        router.navigateToDetailViewController(context: navigationController, job: job)
    }
}

// MARK: - MainInteractorOutput
extension MainPresenter: MainInteractorOutput {
    func changed(userLocation: UserLocation?) {
        view?.changed(viewDataType: ViewDataType.userLocation(userLocation))
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
        
        let tableViewData = MainViewController.TableViewViewData(numberOfSections: 1, numberOfRows: jobs.count, items: items)
        view?.changed(viewDataType: ViewDataType.tableViewData(tableViewData))
    }
}
