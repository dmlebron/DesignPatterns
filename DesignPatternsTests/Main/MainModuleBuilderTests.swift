//
//  MainModuleBuilderTests.swift
//  DesignPatternsTests
//
//  Created by david martinez on 3/5/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import XCTest
@testable import DesignPatterns

class MainModuleBuilderTests: XCTestCase {
    private var mockImageLoader: MockImageLoader!
    private var mockApiClient: MockApiClient!
    private var mockLocationService: MockLocationService!
    
    override func setUp() {
        super.setUp()
        mockImageLoader = MockImageLoader()
        mockApiClient = MockApiClient()
        mockLocationService = MockLocationService()
    }
    
    func test_Module() {
        let module = MainModuleBuilder.init(locationService: mockLocationService, apiClient: mockApiClient, imageLoading: mockImageLoader).module
        let view = module as? MainViewController
        let presenter = view?.presenter as? MainPresenter
        let interactor = presenter?.interactor as? MainInteractor
        let router = presenter?.router as? MainRouter
        
        XCTAssertNotNil(view)
        XCTAssertNotNil(presenter)
        XCTAssertNotNil(interactor)
        XCTAssertNotNil(router)
    }
}
