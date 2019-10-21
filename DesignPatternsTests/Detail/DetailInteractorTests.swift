//
//  DetailInteractorTests.swift
//  DesignPatternsTests
//
//  Created by david martinez on 3/5/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import XCTest
@testable import DesignPatterns

class DetailInteractorTests: XCTestCase {
    private var interactor: DetailInteractor!
    private var mockPresenter: MockDetailPresenter!
    private var mockJob: Job!
    private var mockImageLoader: MockImageLoader!
    private var mockLocationService: MockLocationService!
    
    override func setUp() {
        mockImageLoader = MockImageLoader()
        mockLocationService = MockLocationService()
        mockJob = MockJob.allFields
        mockPresenter = MockDetailPresenter()
        interactor = DetailInteractor(imageLoader: mockImageLoader, job: mockJob, userLocation: nil)
        interactor.set(presenter: mockPresenter)
    }
    
    func test_FetchJob_Calls_Changed_And_Loaded() {
        interactor.fetchJob()
        
        XCTAssertTrue(mockPresenter.didCallChangedJob?.title == mockJob.title)
    }
    
    func test_FetchJob_Calls_Loaded() {
        let mockImage = UIImage(named: "location")!
        mockImageLoader.configureCompletion(image: mockImage)
        interactor.fetchJob()

        XCTAssertTrue(mockPresenter.didCallLoadedCompanyLogo == mockImage)
    }
}

// MARK: - Mock DetailPresenter
class MockDetailPresenter: DetailInteractorOutput {
    var didCallChangedJob: Job?
    func changed(job: Job) {
        didCallChangedJob = job
    }
    
    var didCallLoadedCompanyLogo: UIImage?
    func loaded(companyLogo: UIImage?) {
        didCallLoadedCompanyLogo = companyLogo
    }
}
