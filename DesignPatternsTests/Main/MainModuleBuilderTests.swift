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
    func test_Module() {
        let module = MainModuleBuilder.init().module
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
