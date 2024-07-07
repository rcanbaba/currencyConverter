//
//  CurrencySelectionViewModel.swift
//  currencyConverter
//
//  Created by Can Babaoğlu on 7.07.2024.
//

import Foundation

// TODO: new class
struct CurrencyListItem {
    let name: String
    let country: String
    let code: String
    let flag: String
}

protocol CurrencySelectionViewModelProtocol {
    var list: [CurrencyListItem] { get }
    var filteredCountries: [CurrencyListItem] { get }
    var onCountriesFiltered: (() -> Void)? { get set }
    
    func filterCountries(with query: String)
}

class CurrencySelectionViewModel: CurrencySelectionViewModelProtocol {
    var list: [CurrencyListItem] = []
    var filteredCountries: [CurrencyListItem] = []
    var onCountriesFiltered: (() -> Void)?
    
    init(currencies: [Currency]) {
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
}
