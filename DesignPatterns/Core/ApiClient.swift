//
//  ApiClient.swift
//
//  Created by David Martinez-Lebron on 1/1/18.
//  Copyright © 2018 David Martinez-Lebron. All rights reserved.
//

import UIKit
import Combine

enum Route {
    private var baseUrl: String {
        return "https://jobs.github.com/positions.json"
    }
    case parameters([Parameter: String])
    
    var completeUrl: String {
        if case let Route.parameters(parameters) = self {
            let encodedParams = parameters.reduce("") { result, value in
                guard let htmlEncoded = value.value.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) else { return "" }
                return result + "\(value.key.rawValue)=\(htmlEncoded)&"
            }
            return "\(baseUrl)?\(encodedParams)"
        }
        return baseUrl
    }
}

enum Parameter: String {
    case jobType = "description"
    case location
}

protocol ApiClientType {
    func get(url: URL, completion: @escaping ApiClient.Completion)
    func get(url: URL) -> AnyPublisher<Jobs, Error>
}

final class ApiClient {
    typealias Completion = (Result) -> Void
    
    enum Result {
        case success(Jobs)
        case failed(Error)
    }
}

// MARK: - ApiClientType
extension ApiClient: ApiClientType {
    func get(url: URL, completion: @escaping Completion) {
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else { return }
            
            do {
                let jobs = try JSONDecoder().decode(Jobs.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(jobs))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failed(error))
                }
            }
        }.resume()
    }
    
    func get(url: URL) -> AnyPublisher<Jobs, Error> {
        
        let request = URLRequest(url: url)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: Jobs.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
