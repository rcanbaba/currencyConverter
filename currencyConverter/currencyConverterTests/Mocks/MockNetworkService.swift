//
//  MockNetworkService.swift
//  currencyConverterTests
//
//  Created by Can Babaoğlu on 9.07.2024.
//

import XCTest
@testable import currencyConverter

import Foundation

class MockNetworkService: NetworkServiceProtocol {
    var mockResult: Result<CurrencyRate, Error>?
    var taskCancelled = false
    
    func execute<T: Decodable>(_ request: Request, completion: @escaping (Result<T, Error>) -> Void) {
        if let result = mockResult as? Result<T, Error> {
            completion(result)
        } else {
            completion(.failure(NetworkError.networkRequestFailed))
        }
    }
    
    func cancelTask() {
        taskCancelled = true
    }
}
