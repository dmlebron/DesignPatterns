//
//  MockEnvironment.swift
//  DesignPatternsTests
//
//  Created by david martinez on 2/8/20.
//  Copyright © 2020 dmlebron. All rights reserved.
//

import Foundation
@testable import DesignPatterns

extension Environment {
    static let mock = Environment(apiURLSring: "https://jobs.github.com/positions.json",
                                  apiClient: MockApiClient(),
                                  locationService: MockLocationService(),
                                  color: Color(),
                                  imageLoader: MockImageLoader())
}
