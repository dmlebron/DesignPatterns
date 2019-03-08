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
        mockApiClient.reset()
        mockLocationService.reset()
    }
    
    func test_ViewDidAppear_Calls_UpdateCurrentAddress_NotValidUserLocation() {
        mockLocationService.configureCompletion(location: MockLocation.boston)
        viewModel.viewDidAppear()
        XCTAssertTrue(mockLocationService.didCallCurrentAdrress)
        XCTAssertNotNil(viewModel.userLocation)
    }
    
    func test_ViewDidAppear_Calls_UpdateCurrentAddress_ValidUserLocation() {
        mockLocationService.configureCompletion(location: MockLocation.boston)
        viewModel.viewDidAppear()
        XCTAssertTrue(mockLocationService.didCallCurrentAdrress)
        XCTAssertNotNil(viewModel.userLocation)
    }
    
    func test_UpdateCurrentLocationTapped_Calls_UpdateCurrentAddress() {
        mockLocationService.configureCompletion(location: MockLocation.boston)
        viewModel.updateCurrentLocationTapped()
        XCTAssertTrue(mockLocationService.didCallCurrentAdrress)
        XCTAssertNotNil(viewModel.userLocation)
    }
    
    func test_SearchTapped_ValidQuery_NilLocation() {
        let mockJob = MockJob.allFields
        mockApiClient.configureSuccess(mockJobs: [mockJob])
        
        let query = "ios"
        viewModel.searchTapped(query: query, address: nil)
        XCTAssertFalse(mockLocationService.didCallLocationForAddress)
        XCTAssertNil(mockViewController.location)
        XCTAssertTrue(mockViewController.didCallReloadTableView)
        XCTAssertTrue(viewModel.numberOfRows() == 1)
    }
    
    func test_SearchTapped_ValidQuery_ValidLocation() throws {
        let mockJob = MockJob.onlyTitleNameAndUrl
        mockApiClient.configureSuccess(mockJobs: [mockJob])
        mockLocationService.configureCompletion(location: MockLocation.boston)
        let query = "ios"
        let indexPath = IndexPath(row: 0, section: 0)

        viewModel.searchTapped(query: query, address: "02130")

        XCTAssertTrue(mockLocationService.didCallLocationForAddress)
        XCTAssertNotNil(mockViewController.location)
        XCTAssertTrue(mockViewController.didCallReloadTableView)
        XCTAssertTrue(viewModel.numberOfRows() == 1)
        XCTAssertTrue(viewModel.numberOfSections() == 1)
        XCTAssertTrue(viewModel.jobAtIndexPath(indexPath)?.companyName == mockJob.companyName)
        XCTAssertNil(viewModel.userLocation)
    }

    func test_SearchTapped_EmptyQuery_ValidLocation() throws {
        let mockJob = MockJob.onlyTitleNameAndUrl
        mockApiClient.configureSuccess(mockJobs: [mockJob])
        mockLocationService.configureCompletion(location: MockLocation.boston)
        let query = ""
        let indexPath = IndexPath(row: 0, section: 0)

        viewModel.searchTapped(query: query, address: "02130")

        let viewModelError = mockViewController.error as? MainViewModel.Error

        XCTAssertTrue(mockLocationService.didCallLocationForAddress)
        XCTAssertNotNil(mockViewController.location)
        XCTAssertFalse(mockViewController.didCallReloadTableView)
        XCTAssertTrue(viewModel.numberOfRows() == 0)
        XCTAssertTrue(viewModel.numberOfSections() == 1)
        XCTAssertNil(viewModel.jobAtIndexPath(indexPath))
        XCTAssertTrue(viewModelError?.localizedDescription == MainViewModel.Error.invalidQuery.localizedDescription)
    }

    func test_SearchTapped_ValidQuery_ValidLocation_ApiClientError() throws {
        let error = MockApiClient.Error.response
        mockApiClient.configureFail(error: error)
        mockLocationService.configureCompletion(location: MockLocation.boston)
        let query = "ios"
        let indexPath = IndexPath(row: 0, section: 0)

        viewModel.searchTapped(query: query, address: "02130")

        let apiClientError = mockViewController.error as? MockApiClient.Error

        XCTAssertTrue(mockLocationService.didCallLocationForAddress)
        XCTAssertNotNil(mockViewController.location)
        XCTAssertFalse(mockViewController.didCallReloadTableView)
        XCTAssertTrue(apiClientError?.localizedDescription == MockApiClient.Error.response.localizedDescription)
        XCTAssertTrue(viewModel.numberOfRows() == 0)
        XCTAssertTrue(viewModel.numberOfSections() == 1)
        XCTAssertNil(viewModel.jobAtIndexPath(indexPath))
    }

    func test_CellTapped_ValidIndexPath() {
        let mockJob = MockJob.onlyTitleNameAndUrl
        mockApiClient.configureSuccess(mockJobs: [mockJob])
        mockLocationService.configureCompletion(location: MockLocation.boston)
        let query = "ios"
        let indexPath = IndexPath(row: 0, section: 0)

        viewModel.searchTapped(query: query, address: "02130")
        viewModel.cellTappedAtIndexPath(indexPath)

        let detailViewController = mockViewController.viewControllerToPush as? DetailViewController
        XCTAssertNotNil(mockViewController.viewControllerToPush)
        XCTAssertNotNil(detailViewController)
        XCTAssertNotNil(detailViewController?.viewModel)
    }

    func test_CellTapped_NotValidIndexPath() {
        let mockJob = MockJob.onlyTitleNameAndUrl
        mockApiClient.configureSuccess(mockJobs: [mockJob])
        mockLocationService.configureCompletion(location: MockLocation.boston)
        let query = "ios"
        let indexPath = IndexPath(row: 1, section: 0)

        viewModel.searchTapped(query: query, address: "02130")
        viewModel.cellTappedAtIndexPath(indexPath)

        XCTAssertNil(mockViewController.viewControllerToPush)
    }
    
    // TODO: Add test to handle fetch jobs for different location settings
}

// MARK: - Helpers
private extension MainViewModelTests {
    func resetMockFlags() {
        mockLocationService.didCallLocationForAddress = false
        mockViewController.didCallReloadTableView = false
        mockLocationService.didCallCurrentAdrress = false
        mockViewController.viewControllerToPush = nil
        mockViewController.location = nil
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
    
    var location: Location?
    func locationChanged(_ location: Location?) {
        self.location = location
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
