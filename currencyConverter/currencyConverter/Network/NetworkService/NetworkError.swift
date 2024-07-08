//
//  NetworkError.swift
//  currencyConverter
//
//  Created by Can Babaoğlu on 8.07.2024.
//

import Foundation

enum NetworkError: Error {
    case urlError
    case networkRequestFailed
    case decodingError
    case serverError(statusCode: Int)
    case unknownError
    
    var description: String {
        switch self {
        case .urlError:
            return "There seems to be an issue with the URL. Please try again."
        case .networkRequestFailed:
            return "Network request failed. Please check your connection and try again."
        case .decodingError:
            return "Failed to process the data. Please try again."
        case .serverError(let statusCode):
            return "Server error with status code: \(statusCode). Please try again later."
        case .unknownError:
            return "Something went wrong. Please try again."
        }
    }
}
