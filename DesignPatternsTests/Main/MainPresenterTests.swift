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
        CurrentEnvironment = Environment.mock
        mockInteractor = MockMainInteractor()
        mockRouter = MockMainRouter()
        mockView = MockMainView()
        presenter = MainPresenter(interactor: mockInteractor, router: mockRouter)
        presenter.set(view: mockView)
    }

    func test_ViewDidAppear_Calls_UpdateCurrentAddress() {
        presenter.viewDidAppear()
        XCTAssertTrue(mockInteractor.didCallUpdateCurrentAddress)
    }

    func test_SearchTapped_Calls_InteractorSearchTapped_NoLocation() {
        let query = "ios"
        presenter.searchTapped(query: query, address: nil)

        XCTAssertNil(mockInteractor.didCallSearchTapped?.address)
        XCTAssertTrue(mockInteractor.didCallSearchTapped?.query == query)
    }

    func test_SearchTapped_Calls_InteractorSearchTapped_WithLocation() {
        let query = "ios"
        let location = MockLocation.boston
        presenter.searchTapped(query: query, address: location.city)

        XCTAssertTrue(mockInteractor.didCallSearchTapped?.address == location.city)
        XCTAssertTrue(mockInteractor.didCallSearchTapped?.query == query)
    }
}

// MARK: - Mock MainInteractor
class MockMainInteractor: MainInteractorInput {
    var didCallSetPresenter: MainInteractorOutput?
    func set(presenter: MainInteractorOutput) {
        didCallSetPresenter = presenter
    }

    var didCallSearchTapped: (query: String, address: String?)?
    func searchTapped(query: String, address: String?) {
        didCallSearchTapped = (query: query, address: address)
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
        didCallNavigateToDetail = (job: job, userLocation: userLocation, context: context)
    }
}
