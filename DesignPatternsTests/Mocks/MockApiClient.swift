//
//  MockApiClient.swift
//  DesignPatternsTests
//
//  Created by david martinez on 2/23/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import Foundation
import Combine
@testable import DesignPatterns

class MockApiClient: ApiClientType {
    enum MockError: Swift.Error {
        case response

        var localizedDescription: String {
            switch self {
            case .response:
                return "Invalid response format"
            }
        }
    }


    typealias Result = ApiClient.Result
    typealias Completion = ApiClient.Completion
    
    var url: URL?
    private var expectedResult: ApiClient.Result?
    
    func get(url: URL, completion: @escaping ApiClient.Completion) {
        self.url = url
        if let expectedResult = expectedResult {
            completion(expectedResult)
        }
    }
    
    func get(url: URL) -> AnyPublisher<Jobs, Error> {
        return Future<Jobs, Error> { result in
            result(.success([MockJob.allFields]))
        }
        .eraseToAnyPublisher()
    }
}

// MARK: - Configuration Helper
extension MockApiClient {
    func configureSuccess(mockJobs: Jobs) {
        expectedResult = ApiClient.Result.success(mockJobs)
    }
    
    func configureFail(error: Error) {
        expectedResult = ApiClient.Result.failed(error)
    }
    
    func reset() {
        url = nil
        expectedResult = nil
    }
}
