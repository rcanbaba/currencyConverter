//
//  MockCoordinator.swift
//  currencyConverterTests
//
//  Created by Can Babaoğlu on 9.07.2024.
//

import XCTest
@testable import currencyConverter

class MockCoordinator: Coordinator {
    var navigationController = UINavigationController()
    var currencySelectionPresented = false
    var returnedConverterView = false
    
    var selectedCurrency: Currency?
    var isSender: Bool?
    
    func start() {
        // No-op for mock coordinator
    }
    
    func presentSelectionView(with currencies: [Currency], isSender: Bool) {
        currencySelectionPresented = true
    }
    
    func returnConverterView(with currency: currencyConverter.Currency, isSender: Bool) {
        returnedConverterView = true
        self.isSender = isSender
        selectedCurrency = currency
    }
    
}
