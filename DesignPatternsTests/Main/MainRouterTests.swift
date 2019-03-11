//
//  MainRouterTests.swift
//  DesignPatternsTests
//
//  Created by david martinez on 3/5/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import XCTest
@testable import DesignPatterns

class MainRouterTests: XCTestCase {
    var router: MainRouter!
    
    override func setUp() {
        router = MainRouter()
    }
    
    func test_NavigateToDetailViewController_WithUserLocation() {
        let mockJob = MockJob.allFields
        let mockLocation = MockLocation.boston
        let context = UINavigationController()
        let builder = DetailModuleBuilder()
        
        router.navigateToDetailViewController(job: <#T##Job#>, userLocation: <#T##Location?#>, context: <#T##UINavigationController#>)
    }
}
