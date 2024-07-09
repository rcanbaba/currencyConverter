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

