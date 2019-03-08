//
//  MainPresenterTests.swift
//  DesignPatternsTests
//
//  Created by david martinez on 3/5/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import XCTest
@testable import DesignPatterns

class MainPresenterTests: XCTestCase {
    var presenter: MainPresenter!
    var mockInteractor: MockMainInteractor!
    var mockView: MockMainView!
    var mockRouter: MockMainRouter!

    override func setUp() {
        presenter = MainPresenter(interactor: mockInteractor, router: mockRouter)
    }
}

// MARK: - Mock MainInteractor
class MockMainInteractor: MainInteractorInput {
    var didCallSetPresenter: MainInteractorOutput?
    func set(presenter: MainInteractorOutput) {
        didCallSetPresenter = presenter
    }

    var didCallSearchTappedQuery: String?
    var didCallSearchTappedZipcode: String?
    func searchTapped(query: String, zipcode: String?) {
        didCallSearchTappedQuery = query
        didCallSearchTappedZipcode = zipcode
    }

    var didCallUpdateCurrentAddress = false
    func updateCurrentAddress() {
        didCallUpdateCurrentAddress = true
    }
}

// MARK: - Mock MainView
class MockMainView: MainViewInput {
    var didCallChangedViewDataType: MainViewController.ViewDataType?
    func changed(viewDataType: MainViewController.ViewDataType) {
        didCallChangedViewDataType = viewDataType
    }

    var didCallShowAlertError: Error?
    func showAlert(error: Error) {
        didCallShowAlertError = error
    }
}

// MARK: - Mock MainRouter
class MockMainRouter: MainRouterInput {
    static func navigationControllerForMainModuleSetup(builder: MainModuleBuilder) -> UINavigationController {
        return UINavigationController()
    }

    var didCallNavigateToDetail: (job: Job, userLocation: Location?, context: UINavigationController)?
    func navigateToDetailViewController(job: Job, userLocation: Location?, context: UINavigationController) {
        didCallNavigateToDetail?.job = job
        didCallNavigateToDetail?.userLocation = userLocation
        didCallNavigateToDetail?.context = context
    }
}
