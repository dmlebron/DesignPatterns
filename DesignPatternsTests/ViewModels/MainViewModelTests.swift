//
//  MainViewModelTests.swift
//  DesignPatternsTests
//
//  Created by david martinez on 2/28/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import XCTest
@testable import DesignPatterns

final class MainViewModelTests: XCTestCase {
    var viewModel: MainViewModel!
    var mockViewController: MockMainViewControllerOutput!
    var mockLocationService: MockLocationService!
    var mockApiClient: MockApiClient!
    
    override func setUp() {
        CurrentEnvironment = Environment.mock
        mockViewController = MockMainViewControllerOutput()
        viewModel = MainViewModel(output: mockViewController)
        mockLocationService = CurrentEnvironment.locationService as? MockLocationService
        mockApiClient = CurrentEnvironment.apiClient as? MockApiClient
    }

    override func tearDown() {
        resetMockFlags()
    }
    
    func test_ViewDidAppear_Calls_UpdateCurrentAddress() {
        viewModel.viewDidAppear()
        XCTAssertTrue(mockLocationService.didCallCurrentAdrress)
    }
    
    func test_UpdateCurrentLocationTapped_Calls_UpdateCurrentAddress() {
        viewModel.updateCurrentLocationTapped()
        XCTAssertTrue(mockLocationService.didCallCurrentAdrress)
    }
    
    func test_SearchTapped_ValidQuery_NilLocation() {
        let mockJob = MockJob.allFields
        mockApiClient.configureSuccess(mockJobs: [mockJob])
        
        let query = "ios"
        viewModel.searchTapped(query: query, location: nil)
        XCTAssertFalse(mockLocationService.didCallAddressForPostalCode)
        XCTAssertNil(mockViewController.userLocation)
        XCTAssertTrue(mockViewController.didCallReloadTableView)
        XCTAssertTrue(viewModel.numberOfRows() == 1)
    }
    
    func test_SearchTapped_ValidQuery_ValidLocation() throws {
        let mockJob = MockJob.onlyTitleNameAndUrl
        mockApiClient.configureSuccess(mockJobs: [mockJob])
        mockLocationService.expectedUserLocation = MockUserLocation.boston
        let query = "ios"
        let indexPath = IndexPath(row: 0, section: 0)

        viewModel.searchTapped(query: query, location: "02130")

        XCTAssertTrue(mockLocationService.didCallAddressForPostalCode)
        XCTAssertNotNil(mockViewController.userLocation)
        XCTAssertTrue(mockViewController.didCallReloadTableView)
        XCTAssertTrue(viewModel.numberOfRows() == 1)
        XCTAssertTrue(viewModel.numberOfSections() == 1)
        XCTAssertTrue(viewModel.jobAtIndexPath(indexPath)?.companyName == mockJob.companyName)
    }

    func test_SearchTapped_EmptyQuery_ValidLocation() throws {
        let mockJob = MockJob.onlyTitleNameAndUrl
        mockApiClient.configureSuccess(mockJobs: [mockJob])
        mockLocationService.expectedUserLocation = MockUserLocation.boston
        let query = ""
        let indexPath = IndexPath(row: 0, section: 0)

        viewModel.searchTapped(query: query, location: "02130")

        let viewModelError = mockViewController.error as? MainViewModel.Error

        XCTAssertTrue(mockLocationService.didCallAddressForPostalCode)
        XCTAssertNotNil(mockViewController.userLocation)
        XCTAssertFalse(mockViewController.didCallReloadTableView)
        XCTAssertTrue(viewModel.numberOfRows() == 0)
        XCTAssertTrue(viewModel.numberOfSections() == 1)
        XCTAssertNil(viewModel.jobAtIndexPath(indexPath))
        XCTAssertTrue(viewModelError?.localizedDescription == MainViewModel.Error.invalidQuery.localizedDescription)
    }

    func test_SearchTapped_ValidQuery_ValidLocation_ApiClientError() throws {
        let error = MockApiClient.Error.response
        mockApiClient.configureFail(error: error)
        mockLocationService.expectedUserLocation = MockUserLocation.boston
        let query = "ios"
        let indexPath = IndexPath(row: 0, section: 0)

        viewModel.searchTapped(query: query, location: "02130")

        let apiClientError = mockViewController.error as? MockApiClient.Error

        XCTAssertTrue(mockLocationService.didCallAddressForPostalCode)
        XCTAssertNotNil(mockViewController.userLocation)
        XCTAssertFalse(mockViewController.didCallReloadTableView)
        XCTAssertTrue(apiClientError?.localizedDescription == MockApiClient.Error.response.localizedDescription)
        XCTAssertTrue(viewModel.numberOfRows() == 0)
        XCTAssertTrue(viewModel.numberOfSections() == 1)
        XCTAssertNil(viewModel.jobAtIndexPath(indexPath))
    }

    func test_CellTapped_ValidIndexPath() {
        let mockJob = MockJob.onlyTitleNameAndUrl
        mockApiClient.configureSuccess(mockJobs: [mockJob])
        mockLocationService.expectedUserLocation = MockUserLocation.boston
        let query = "ios"
        let indexPath = IndexPath(row: 0, section: 0)

        viewModel.searchTapped(query: query, location: "02130")
        viewModel.cellTappedAtIndexPath(indexPath)

        let detailViewController = mockViewController.viewControllerToPush as? DetailViewController
        XCTAssertNotNil(mockViewController.viewControllerToPush)
        XCTAssertNotNil(detailViewController)
        XCTAssertNotNil(detailViewController?.viewModel)
    }

    func test_CellTapped_NotValidIndexPath() {
        let mockJob = MockJob.onlyTitleNameAndUrl
        mockApiClient.configureSuccess(mockJobs: [mockJob])
        mockLocationService.expectedUserLocation = MockUserLocation.boston
        let query = "ios"
        let indexPath = IndexPath(row: 1, section: 0)

        viewModel.searchTapped(query: query, location: "02130")
        viewModel.cellTappedAtIndexPath(indexPath)

        XCTAssertNil(mockViewController.viewControllerToPush)
    }
}

// MARK: - Helpers
private extension MainViewModelTests {
    func resetMockFlags() {
        mockLocationService.didCallAddressForPostalCode = false
        mockViewController.didCallReloadTableView = false
        mockLocationService.didCallCurrentAdrress = false
        mockViewController.viewControllerToPush = nil
        mockViewController.userLocation = nil
    }
}

// MARK: - MainViewModelOutput
class MockMainViewControllerOutput: MainViewModelOutput {
    
    var viewModel: MainViewModelInput?
    func set(viewModel: MainViewModelInput) {
        self.viewModel = viewModel
    }
    
    var didCallReloadTableView = false
    func reloadTableView() {
        didCallReloadTableView = true
    }
    
    var userLocation: UserLocation?
    func userLocationChanged(_ userLocation: UserLocation?) {
        self.userLocation = userLocation
    }
    
    var error: Error?
    func showAlert(error: Error) {
        self.error = error
    }
    
    var viewControllerToPush: UIViewController?
    func pushViewController(_ viewController: UIViewController) {
        self.viewControllerToPush = viewController
    }
}
