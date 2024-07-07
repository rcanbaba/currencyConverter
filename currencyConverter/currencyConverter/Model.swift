//
//  Model.swift
//  currencyConverter
//
//  Created by Can Babaoğlu on 7.07.2024.
//

import Foundation

struct CurrencyRate: Codable {
    let from: String
    let to: String
    let rate: Double
}

enum Currency: String, CaseIterable {
    case PLN
    case EUR
    case GBP
    case UAH
    
    static let limits: [Currency: Double] = [
        .PLN: 20000,
        .EUR: 5000,
        .GBP: 1000,
        .UAH: 50000
    ]
}

