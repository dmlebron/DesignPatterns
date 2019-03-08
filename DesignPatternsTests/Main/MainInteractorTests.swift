//
//  MainInteractorTests.swift
//  DesignPatternsTests
//
//  Created by david martinez on 3/5/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import XCTest
@testable import DesignPatterns

class MainInteractorTests: XCTestCase {
    var interactor: MainInteractor!
    var mockPresenter: MockMainPresenter!
    var mockApiClient: MockApiClient!
    var mockLocationService: MockLocationService!
    
    override func setUp() {
        CurrentEnvironment = Environment.mock
        mockApiClient = CurrentEnvironment.apiClient as? MockApiClient
        mockLocationService = CurrentEnvironment.locationService as? MockLocationService
        mockPresenter = MockMainPresenter()
        interactor = MainInteractor()
        interactor.set(presenter: mockPresenter)
    }
    
    override func tearDown() {
        mockApiClient.reset()
        mockLocationService.reset()
    }
    
    func test_SetPresenter() {
        interactor = MainInteractor()
        
        XCTAssertNil(interactor.presenter)
        
        interactor.set(presenter: mockPresenter)
        
        XCTAssertNotNil(interactor.presenter)
    }
    
    func test_SearchTapped_Calls_ApiClient_NoZipcode() {
        let query = "ios"
        mockApiClient.configureSuccess(mockJobs: [MockJob.allFields])
        interactor.searchTapped(query: query, zipcode: nil)
        
        XCTAssertNotNil(mockApiClient.url)
        XCTAssertFalse(mockLocationService.didCallAddressForPostalCode)
        XCTAssertNil(mockPresenter?.didCallFailed)
        XCTAssertNotNil(mockPresenter.didCallChangedJobs)
    }

    func test_SearchTapped_Calls_ApiClient_NoZipcode_Failed() {
        let query = "ios"
        mockApiClient.configureFail(error: MockApiClient.Error.response)
        interactor.searchTapped(query: query, zipcode: nil)

        XCTAssertNotNil(mockApiClient.url)
        XCTAssertFalse(mockLocationService.didCallAddressForPostalCode)
        XCTAssertNotNil(mockPresenter?.didCallFailed)
        XCTAssertNil(mockPresenter.didCallChangedJobs)
    }
    
    func test_SearchTapped_Calls_ApiClient_And_LocationService() {
        let query = "ios"
        let zipcode = "02189"
        interactor.searchTapped(query: query, zipcode: zipcode)
        
        XCTAssertNotNil(mockApiClient.url)
        XCTAssertTrue(mockLocationService.didCallAddressForPostalCode)
    }
}

// MARK: - Mock MainPresenter
class MockMainPresenter: MainInteractorOutput {
    var didCallLocationChanged: Location?
    func changed(location: Location?) {
        didCallLocationChanged = location
    }
    
    var didCallUserLocationChanged: Location?
    func changed(userLocation: Location?) {
        didCallUserLocationChanged = userLocation
    }
    
    var didCallChangedJobs: Jobs?
    func changed(jobs: Jobs) {
        didCallChangedJobs = jobs
    }
    
    var didCallFailed: Error?
    func failed(error: Error) {
        didCallFailed = error
    }
}
