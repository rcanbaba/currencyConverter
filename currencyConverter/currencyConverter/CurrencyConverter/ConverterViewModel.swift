//
//  ConverterViewModel.swift
//  currencyConverter
//
//  Created by Can Babaoğlu on 7.07.2024.
//

import Foundation

// TODO: UIKit in viewModel ??? get UIImage from another way
import UIKit

protocol CurrencyViewModelProtocol {
    var onRatesFetched: ((CurrencyRate) -> Void)? { get set }
    var onError: ((Error) -> Void)? { get set }
    var onError2: ((String) -> Void)? { get set }
    var onReceiverAmountError: ((String) -> Void)? { get set }
    
    var onFetchRequest: (() -> Void)? { get set }
    
    var updateReceiverAmount: ((String) -> Void)? { get set }
    var updateSenderAmount: ((String) -> Void)? { get set }
    
    var updateRateText: ((String) -> Void)? { get set }
    var updateSenderCurrencyText: ((String) -> Void)? { get set }
    var updateSenderCurrencyImage: ((UIImage?) -> Void)? { get set }
    
    var updateReceiverCurrencyText: ((String) -> Void)? { get set }
    var updateReceiverCurrencyImage: ((UIImage?) -> Void)? { get set }
    

    func cancelFetchRates()
    func validateAmount(_ amount: Double, for currency: Currency) -> Bool
    func setFromCurrency(_ currency: Currency)
    func setToCurrency(_ currency: Currency)
    func senderAmountUpdated(_ text: String?)
    func receiverAmountUpdated(_ text: String?)
    func changeSenderCurrencyTapped()
    func changeReceiverCurrencyTapped()
    func changeSenderCurrency(_ currency: Currency)
    func changeReceiverCurrency(_ currency: Currency)
    func setDefaultValues()
}


class CurrencyViewModel: CurrencyViewModelProtocol {
    
    private let currencyService: CurrencyServiceProtocol
    private let coordinator: Coordinator
    
    var onRatesFetched: ((CurrencyRate) -> Void)?
    var onError: ((Error) -> Void)?
    var onError2: ((String) -> Void)?
    var onReceiverAmountError: ((String) -> Void)?
    
    var onFetchRequest: (() -> Void)?
    
    var updateReceiverAmount: ((String) -> Void)?
    var updateSenderAmount: ((String) -> Void)?
    
    var updateRateText: ((String) -> Void)?
    var updateSenderCurrencyText: ((String) -> Void)?
    var updateSenderCurrencyImage: ((UIImage?) -> Void)?
    var updateReceiverCurrencyText: ((String) -> Void)?
    var updateReceiverCurrencyImage: ((UIImage?) -> Void)?
    
    private var senderCurrency: Currency = .PLN
    private var receiverCurrency: Currency = .UAH
    private var senderAmount: String = "300.000"
    private var receiverAmount: String = ""
    private var rate: Double = .zero
    
    init(currencyService: CurrencyServiceProtocol, coordinator: Coordinator) {
        self.currencyService = currencyService
        self.coordinator = coordinator
    }
    
    func fetchRates(fromCurrency: Currency, toCurrency: Currency, amount: Double, isSender: Bool) {
        
        onFetchRequest?()
        
        Logger.info("from: \(fromCurrency.rawValue) - to: \(toCurrency.rawValue) - amount: \(amount) - isSender: \(isSender)")
        
        Logger.info("sender: \(senderCurrency.rawValue) - to: \(receiverCurrency.rawValue) - SenderAmount: \(senderAmount) - ReceiverAmount: \(receiverAmount)")

        Logger.info("Request sended on vm")
        currencyService.fetchRates(from: fromCurrency.rawValue, to: toCurrency.rawValue, amount: amount) { [weak self] result in
            guard let self = self else { return }
            Logger.info("Response on vm")
            switch result {
            case .success(let rate):
                self.onRatesFetched?(rate)
                
                let convertedAmount = self.calculateConvertedAmount(requestAmount: amount, rate: rate.rate)
                let formattedAmount = self.formatAmount(convertedAmount)
                if isSender {
                    self.receiverAmount = formattedAmount
                    self.updateReceiverAmount?(formattedAmount)
                } else {
                    self.senderAmount = formattedAmount
                    guard validateAmount(convertedAmount, for: senderCurrency) else {
                        sendSenderValidationError(for: senderCurrency)
                        return
                    }
                    self.updateSenderAmount?(formattedAmount)
                }
                
                let rateText = getRateText(from: fromCurrency.rawValue, to: toCurrency.rawValue, rate: self.formatAmount(rate.rate))
                self.updateRateText?(rateText)
                
            case .failure(let error):
                self.onError?(error)
            }
        }
    }
    
    private func getRateText(from: String, to: String, rate: String) -> String {
        return "1 \(from) = \(rate) \(to)"
    }
    
    func formatAmount(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.usesGroupingSeparator = false
        return formatter.string(from: NSNumber(value: amount)) ?? ""
    }
    
    func calculateConvertedAmount(requestAmount: Double, rate: Double) -> Double {
        return requestAmount * rate
    }
    
    func cancelFetchRates() {
        currencyService.cancelFetchRates()
    }
    
    func validateAmount(_ amount: Double, for currency: Currency) -> Bool {
        guard let limit = Currency.limits[currency] else {
            return false
        }
        return amount <= limit
    }
    
    func sendSenderValidationError(for currency: Currency) {
        let errorPreText = "Maximum sending amount: "
        onReceiverAmountError?(errorPreText + Currency.limitsString[currency]! + " " + currency.rawValue)
    }
    
    func setFromCurrency(_ currency: Currency) {
        senderCurrency = currency
    }
    
    func setToCurrency(_ currency: Currency) {
        receiverCurrency = currency
    }
    
    func senderAmountUpdated(_ text: String?) {
        // en sağda 1 virgül kaldıysa trimle
        senderAmount = text ?? ""
        guard let amount = senderAmount.toDouble() else {
            Logger.warning("senderAmountUpdated conversion Error, \(text ?? "null")")
            currencyService.cancelFetchRates()
            self.updateReceiverAmount?("")
            return
        }
        
        guard validateAmount(amount, for: senderCurrency) else {
            currencyService.cancelFetchRates()
            sendSenderValidationError(for: senderCurrency)
            return
        }
        
        fetchRates(fromCurrency: senderCurrency, toCurrency: receiverCurrency, amount: amount, isSender: true)
    }
    
    func receiverAmountUpdated(_ text: String?) {
        receiverAmount = text ?? ""
        guard let amount = receiverAmount.toDouble() else {
            Logger.warning("receiverAmountUpdated conversion Error, \(text ?? "null")")
            currencyService.cancelFetchRates()
            self.updateSenderAmount?("")
            return
        }
        fetchRates(fromCurrency: receiverCurrency, toCurrency: senderCurrency, amount: amount, isSender: false)
    }
    
    func changeSenderCurrencyTapped() {
        let currencyList = getSelectableCurrencies(hiddenCurrency: receiverCurrency)
        coordinator.presentSelectionView(with: currencyList, isSender: true)
    }
    
    func changeReceiverCurrencyTapped() {
        let currencyList = getSelectableCurrencies(hiddenCurrency: senderCurrency)
        coordinator.presentSelectionView(with: currencyList, isSender: false)
    }
    
    func getSelectableCurrencies(hiddenCurrency: Currency) -> [Currency] {
        return Currency.allCases.filter { $0 != hiddenCurrency }
    }
    
    func changeSenderCurrency(_ currency: Currency) {
        guard !checkCurrencyIsSame(new: currency, old: senderCurrency) else { return }
        let currencyText = currency.rawValue
        let currencyImage = UIImage(named: currency.currencyFlagImageName)
        
        senderCurrency = currency
        
        updateSenderCurrencyText?(currencyText)
        updateSenderCurrencyImage?(currencyImage)
        
        guard let amount = senderAmount.toDouble() else {
            Logger.warning("receiverAmountUpdated change conversion Error, \(senderAmount)")
            currencyService.cancelFetchRates()
            self.updateSenderAmount?("")
            return
        }
        fetchRates(fromCurrency: senderCurrency, toCurrency: receiverCurrency, amount: amount, isSender: true)
    }
    
    func changeReceiverCurrency(_ currency: Currency) {
        guard !checkCurrencyIsSame(new: currency, old: receiverCurrency) else { return }
        let currencyText = currency.rawValue
        let currencyImage = UIImage(named: currency.currencyFlagImageName)
        
        receiverCurrency = currency
        
        updateReceiverCurrencyText?(currencyText)
        updateReceiverCurrencyImage?(currencyImage)
        
        guard let amount = receiverAmount.toDouble() else {
            Logger.warning("receiverAmountUpdated change conversion Error, \(receiverAmount)")
            currencyService.cancelFetchRates()
            self.updateReceiverAmount?("")
            return
        }
        fetchRates(fromCurrency: receiverCurrency, toCurrency: senderCurrency, amount: amount, isSender: false)
    }
    
    func checkCurrencyIsSame(new: Currency, old: Currency) -> Bool {
        return new == old
    }
    
    // it is initial set from task
    func setDefaultValues() {
        senderCurrency = .PLN
        receiverCurrency = .UAH
        senderAmount = "300"
        receiverAmount = ""
        
        updateSenderAmount?(senderAmount)
        updateSenderCurrencyText?(senderCurrency.rawValue)
        updateSenderCurrencyImage?(UIImage(named: senderCurrency.currencyFlagImageName))
        updateReceiverCurrencyText?(receiverCurrency.rawValue)
        updateReceiverCurrencyImage?(UIImage(named: receiverCurrency.currencyFlagImageName))
        
        let amount = senderAmount.toDouble() ?? 300
        fetchRates(fromCurrency: senderCurrency, toCurrency: receiverCurrency, amount: amount, isSender: true)
    }
    
}

extension String {
    func toDouble() -> Double? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        return formatter.number(from: self)?.doubleValue
    }
}
