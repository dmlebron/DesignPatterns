//
//  MockApiClient.swift
//  DesignPatternsTests
//
//  Created by david martinez on 2/23/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import Foundation

class MockApiClient: ApiClientType {
    typealias Result = ApiClient.Result
    typealias Completion = ApiClient.Completion
    var url: URL?
    var expectedResult: ApiClient.Result?
    func get(url: URL, completion: @escaping Completion) {
        self.url = url
        if let expectedResult = expectedResult {
            completion(expectedResult)
        }
    }
}

// MARK: - Configuration Helper
extension MockApiClient {
    func configureSuccess(mockJobQty: Int) {
        
    }
    
    func configureFail(error: Error) {
        
    }
}
