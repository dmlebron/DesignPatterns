//
//  DetailViewModelTests.swift
//  DesignPatternsTests
//
//  Created by David Martinez-Lebron on 3/1/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import XCTest
@testable import DesignPatterns

class DetailViewModelTests: XCTestCase {
    var viewModel: DetailViewModel!
    var mockViewController: MockDetailViewControllerOutput!
    var mockLocationService: MockLocationService!
    var mockApiClient: MockApiClient!
    var mockImageLoader: MockImageLoader!
    var job: Job!

    override func setUp() {
        job = MockJob.allFields
        CurrentEnvironment = Environment.mock
        mockViewController = MockDetailViewControllerOutput()
        viewModel = DetailViewModel(output: mockViewController, job: job)
        mockLocationService = CurrentEnvironment.locationService as? MockLocationService
        mockApiClient = CurrentEnvironment.apiClient as? MockApiClient
        mockImageLoader = CurrentEnvironment.imageLoader as? MockImageLoader
    }

    override func tearDown() {
        mockApiClient.reset()
        mockLocationService.reset()
    }

    func test_ViewDidLoad_AllData() {
        mockImageLoader.configureCompletion(image: UIImage())
        viewModel.viewDidLoad()
        
        XCTAssertNotNil(mockViewController.companyLogo)
        XCTAssertNotNil(mockViewController.websiteUrlState)
        XCTAssertNotNil(mockViewController.viewData)
    }
    
    func test_ViewDidLoad_NoWebsite() {
        viewModel = DetailViewModel(output: mockViewController, job: MockJob.onlyTitleLocationAndName)
        viewModel.viewDidLoad()
        XCTAssertTrue(mockViewController.websiteUrlState?.isEnabled == false)
        XCTAssertTrue(mockViewController.websiteUrlState?.title == DetailViewModel.Constants.noUrlString)
        XCTAssertNotNil(mockViewController.viewData)
    }

    func test_ShowReadMoreButton_True() {
        viewModel.shouldShowReadMoreButton(isDescriptionLabelTruncated: true)
        XCTAssertTrue(mockViewController.didCallShowReadMoreButton)
    }

    func test_ShowReadMoreButton_False() {
        viewModel.shouldShowReadMoreButton(isDescriptionLabelTruncated: false)
        XCTAssertFalse(mockViewController.didCallShowReadMoreButton)
    }

    func test_WebsiteButtonTapped() {
        viewModel.websiteButtonTapped()

        XCTAssertNotNil(mockViewController.url)
    }

    func test_ReadMoreButtonTapped_Valid() {
        viewModel.readMoreButtonTapped()

        let descriptionViewController = mockViewController.didCallPushViewController as? JobDescriptionViewController
        XCTAssertNotNil(descriptionViewController)
    }
}

class MockDetailViewControllerOutput: DetailViewModelOutput {
    var viewData: DetailViewController.ViewData?
    func changed(viewData: DetailViewController.ViewData) {
        self.viewData = viewData
    }

    var viewModel: DetailViewModelInput?
    func set(viewModel: DetailViewModelInput) {
        self.viewModel = viewModel
    }

    var companyLogo: UIImage?
    func set(companyLogo: UIImage?) {
        self.companyLogo = companyLogo
    }

    var websiteUrlState: DetailViewController.WebsiteUrlState?
    func set(websiteUrlState: DetailViewController.WebsiteUrlState) {
        self.websiteUrlState = websiteUrlState
    }

    var url: URL?
    func openUrl(_ url: URL) {
        self.url = url
    }

    var didCallShowReadMoreButton = false
    func showReadMoreButton() {
        didCallShowReadMoreButton = true
    }

    var didCallPushViewController: UIViewController?
    func pushViewController(_ viewController: UIViewController) {
        didCallPushViewController = viewController
    }
}
