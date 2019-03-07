//
//  DetailModuleBuilderTests.swift
//  DesignPatternsTests
//
//  Created by david martinez on 3/5/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import XCTest
@testable import DesignPatterns

class DetailModuleBuilderTests: XCTestCase {
    func test_Module_UserLocation() {
        let mockJob = MockJob.allFields
        let mockUserLocation = MockLocation.boston
        let module = DetailModuleBuilder.init().module(job: mockJob, userLocation: mockUserLocation)
        
        let view = module as? DetailViewController
        let presenter = view?.presenter as? DetailPresenter
        let interactor = presenter?.interactor as? DetailInteractor
        let router = presenter?.router as? DetailRouter
        let userLocation = interactor?.userLocation
        
        XCTAssertNotNil(view)
        XCTAssertNotNil(presenter)
        XCTAssertNotNil(interactor)
        XCTAssertNotNil(router)
        XCTAssertNotNil(userLocation)
    }
    
    func test_Module_NoUserLocation() {
        let mockJob = MockJob.allFields
        let module = DetailModuleBuilder.init().module(job: mockJob, userLocation: nil)
        
        let view = module as? DetailViewController
        let presenter = view?.presenter as? DetailPresenter
        let interactor = presenter?.interactor as? DetailInteractor
        let router = presenter?.router as? DetailRouter
        let userLocation = interactor?.userLocation
        
        XCTAssertNotNil(view)
        XCTAssertNotNil(presenter)
        XCTAssertNotNil(interactor)
        XCTAssertNotNil(router)
        XCTAssertNil(userLocation)
    }
}
