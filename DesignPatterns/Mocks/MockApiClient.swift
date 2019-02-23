//
//  MockApiClient.swift
//  DesignPatternsTests
//
//  Created by david martinez on 2/23/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import Foundation

class MockApiClient: ApiClientType {
    var url: URL?
    var expectedResult: ApiClient.Result?
    func get(url: URL, completion: @escaping ApiClient.Completion) {
        self.url = url
        if let expectedResult = expectedResult {
            completion(expectedResult)
        }
    }
}
