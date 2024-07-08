//
//  DependencyInjector.swift
//  currencyConverter
//
//  Created by Can Babaoğlu on 7.07.2024.
//

import Foundation

// TODO: this implementation wrong, hold 1 singleton network service, check swinject implementations
class DependencyInjector {
    static let shared = DependencyInjector()
    
    private init() {}
    
    func provideCurrencyService() -> CurrencyServiceProtocol {
        return CurrencyService()
    }
}
