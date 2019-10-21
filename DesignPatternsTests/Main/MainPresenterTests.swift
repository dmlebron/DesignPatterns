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
    var mockImageLoader: MockImageLoader!

    override func setUp() {
        mockInteractor = MockMainInteractor()
        mockRouter = MockMainRouter()
        mockView = MockMainView()
        mockImageLoader = MockImageLoader()
        presenter = MainPresenter(interactor: mockInteractor, router: mockRouter, imageLoading: mockImageLoader)
        presenter.set(view: mockView)
    }

    func test_ViewDidAppear_Calls_UpdateCurrentAddress() {
        presenter.viewDidAppear()
        XCTAssertTrue(mockInteractor.didCallUpdateCurrentAddress)
    }

    func test_SearchTapped_Calls_SearchTapped_NoLocation() {
        let query = "ios"
        presenter.searchTapped(query: query, address: nil)

        XCTAssertNil(mockInteractor.didCallSearchTapped?.address)
        XCTAssertTrue(mockInteractor.didCallSearchTapped?.query == query)
    }

    func test_SearchTapped_Calls_SearchTapped_WithLocation() {
        let query = "ios"
        let location = MockLocation.boston
        presenter.searchTapped(query: query, address: location.city)

        XCTAssertTrue(mockInteractor.didCallSearchTapped?.address == location.city)
        XCTAssertTrue(mockInteractor.didCallSearchTapped?.query == query)
    }

    func test_UpdateCurrentAddress_Calls_UpdateCurrentAddress() {
        presenter.updateCurrentLocationTapped()
        XCTAssertTrue(mockInteractor.didCallUpdateCurrentAddress)
    }

    func test_CellTapped_Calls_NavigateToDetail_NoUserLocation() {
        let job = MockJob.onlyTitleLocationAndName
        let nav = UINavigationController()
        presenter.cellTapped(job: job, navigationController: nav)

        XCTAssertTrue(mockRouter.didCallNavigateToDetail?.job.title == job.title)
        XCTAssertNil(mockRouter.didCallNavigateToDetail?.userLocation)
    }

    func test_CellTapped_Calls_NavigateToDetail_WithUserLocation() {
        let job = MockJob.onlyTitleLocationAndName
        let userLocation = MockLocation.boston
        let nav = UINavigationController()
        presenter.changed(userLocation: userLocation)
        presenter.cellTapped(job: job, navigationController: nav)

        XCTAssertTrue(mockRouter.didCallNavigateToDetail?.job.title == job.title)
        XCTAssertTrue(mockRouter.didCallNavigateToDetail?.userLocation?.city == userLocation.city)
    }

    func test_ChangedLocation_Calls_ChangeDataTypeLocation() {
        let mockLocation = MockLocation.boston
        presenter.changed(userLocation: mockLocation)

        switch mockView.didCallChangedViewDataType! {
        case .location(let location):
            XCTAssertTrue(location?.city == mockLocation.city)
        default: XCTFail()
        }
    }

    func test_ChangedUserLocation_Calls_ChangeDataTypeLocation_And_UpdateUserLocation() {
        let mockLocation = MockLocation.boston
        presenter.changed(userLocation: mockLocation)

        switch mockView.didCallChangedViewDataType! {
        case .location(let location):
            XCTAssertTrue(location?.city == mockLocation.city)
            XCTAssertTrue(presenter.userLocation?.city == mockLocation.city)
        default: XCTFail()
        }
    }

    func test_ChangedJobs_Calls_ChangeDataTypeTableViewData() {
        let mockJobs = [MockJob.allFields, MockJob.onlyTitleLocationAndName, MockJob.onlyTitleNameAndUrl]
        presenter.changed(jobs: mockJobs)

        switch mockView.didCallChangedViewDataType! {
        case .tableViewData(let viewData):
            XCTAssertTrue(viewData.numberOfRows == mockJobs.count)
            XCTAssertTrue(viewData.items[IndexPath(row: 0, section: 0)]?.title == mockJobs.first?.title)
        default: XCTFail()
        }
    }

    func test_Failed_Calls_ShowAlert() {
        let error = MockApiClient.Error.response
        presenter.failed(error: error)
        let responseError = mockView.didCallShowAlertError  as? MockApiClient.Error
        XCTAssertTrue(responseError?.localizedDescription == error.localizedDescription)
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

    var didCallNavigateToDetail: (imageLoading: ImageLoading, job: Job, userLocation: Location?, context: UINavigationController)?
    func navigateToDetailViewController(imageLoading: ImageLoading, job: Job, userLocation: Location?, context: UINavigationController) {
        didCallNavigateToDetail = (imageLoading: imageLoading, job: job, userLocation: userLocation, context: context)
    }
}
