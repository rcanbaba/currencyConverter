//
//  CurrencySelectionViewModel.swift
//  currencyConverter
//
//  Created by Can Babaoğlu on 7.07.2024.
//

import Foundation

protocol CurrencySelectionViewModelProtocol {
    var list: [CurrencyListItem] { get }
    var filteredCountries: [CurrencyListItem] { get }
    var onCountriesFiltered: (() -> Void)? { get set }
    var isSender: Bool { get }
    var titleText: String { get }
    func filterCountries(with query: String)
    func currencySelected(with currency: Currency)
}

final class CurrencySelectionViewModel: CurrencySelectionViewModelProtocol {
    
    private let coordinator: Coordinator
    var list: [CurrencyListItem] = []
    var isSender: Bool
    var filteredCountries: [CurrencyListItem] = []
    var onCountriesFiltered: (() -> Void)?
    
    var titleText: String {
        return isSender ? "Receiving from" : "Sending to"
    }
    
    init(coordinator: Coordinator, currencies: [Currency], isSender: Bool) {
        self.coordinator = coordinator
        self.isSender = isSender
        self.list = currencies.map { currency in
            return CurrencyListItem(
                name: currency.currencyName,
                country: currency.currencyCountry,
                code: currency.rawValue,
                flag: currency.currencyFlagImageName
            )
        }
        self.filteredCountries = list
    }
    
    func filterCountries(with query: String) {
        if query.isEmpty {
            filteredCountries = list
        } else {
            filteredCountries = list.filter { $0.country.lowercased().contains(query.lowercased()) }
        }
        onCountriesFiltered?()
    }
    
    func currencySelected(with currency: Currency) {
        coordinator.returnConverterView(with: currency, isSender: self.isSender)
    }
}
