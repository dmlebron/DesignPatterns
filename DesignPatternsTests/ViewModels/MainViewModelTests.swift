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
    
    func test_ViewDidAppear_Calls_UpdateCurrentAddress() {
        viewModel.viewDidAppear()
        XCTAssertTrue(mockLocationService.didCallCurrentAdrress)
    }
    
    func test_UpdateCurrentLocationTapped_Calls_UpdateCurrentAddress() {
        viewModel.updateCurrentLocationTapped()
        XCTAssertTrue(mockLocationService.didCallCurrentAdrress)
    }
}

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
