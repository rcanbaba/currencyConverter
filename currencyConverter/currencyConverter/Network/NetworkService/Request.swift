//
//  Request.swift
//  currencyConverter
//
//  Created by Can Babaoğlu on 8.07.2024.
//

import Foundation

protocol Request {
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
}
