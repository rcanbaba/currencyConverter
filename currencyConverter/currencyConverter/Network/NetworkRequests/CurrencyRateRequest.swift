//
//  CurrencyRateRequest.swift
//  currencyConverter
//
//  Created by Can Babaoğlu on 8.07.2024.
//

import Foundation

struct CurrencyRateRequest: Request {
    let from: String
    let to: String
    let amount: Double
    
    var path: String {
        return "/api/fx-rates?from=\(from)&to=\(to)&amount=\(amount)"
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
