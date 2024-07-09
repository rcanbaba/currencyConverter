//
//  CurrencyModel.swift
//  currencyConverter
//
//  Created by Can Babaoğlu on 8.07.2024.
//

import Foundation
import UIKit

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
    
    static let limitsString: [Currency: String] = [
        .PLN: "20 000",
        .EUR: "5 000",
        .GBP: "1 000",
        .UAH: "50 000"
    ]
    
    var maxAmountText: String {
        switch self {
        case .UAH:
            return "50 000"
        case .EUR:
            return "5 000"
        case .GBP:
            return "1 000"
        case .PLN:
            return "20 000"
        }
    }
    
    var currencyName: String {
        switch self {
        case .UAH:
            return "Hrivna"
        case .EUR:
            return "Euro"
        case .GBP:
            return "British Pound"
        case .PLN:
            return "Polski Zloty"
        }
    }
    
    var currencyCountry: String {
        switch self {
        case .UAH:
            return "Ukraine"
        case .EUR:
            return "Germany"
        case .GBP:
            return "Great Britain"
        case .PLN:
            return "Poland"
        }
    }
    
    var currencyFlagImageName: String {
        switch self {
        case .UAH:
            return "uah-flag-icon"
        case .EUR:
            return "eur-flag-icon"
        case .GBP:
            return "gbp-flag-icon"
        case .PLN:
            return "pln-flag-icon"
        }
    }
    
    var currencyFlagImage: UIImage? {
        switch self {
        case .UAH:
            return UIImage(named: "uah-flag-icon")
        case .EUR:
            return UIImage(named: "eur-flag-icon")
        case .GBP:
            return UIImage(named: "gbp-flag-icon")
        case .PLN:
            return UIImage(named: "pln-flag-icon")
        }
    }
}
