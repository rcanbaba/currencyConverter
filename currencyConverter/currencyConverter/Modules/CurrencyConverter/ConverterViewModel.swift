//
//  ConverterViewModel.swift
//  currencyConverter
//
//  Created by Can Babaoğlu on 7.07.2024.
//

import Foundation

protocol CurrencyViewModelProtocol {
    var onError: ((String, String) -> Void)? { get set }
    var onSenderAmountError: ((String) -> Void)? { get set }
    
    var onFetchRequest: (() -> Void)? { get set }
    
    var updateReceiverAmount: ((String) -> Void)? { get set }
    var updateSenderAmount: ((String) -> Void)? { get set }
    
    var updateRateText: ((String) -> Void)? { get set }
    var updateSenderCurrencyText: ((String) -> Void)? { get set }
    var updateSenderCurrencyImage: ((Currency) -> Void)? { get set }
    
    var updateReceiverCurrencyText: ((String) -> Void)? { get set }
    var updateReceiverCurrencyImage: ((Currency) -> Void)? { get set }
    
    func validateAmount(_ amount: Double, for currency: Currency) -> Bool

    func senderAmountUpdated(_ text: String?)
    func receiverAmountUpdated(_ text: String?)
    func changeSenderCurrencyTapped()
    func changeReceiverCurrencyTapped()
    func changeSenderCurrency(_ currency: Currency)
    func changeReceiverCurrency(_ currency: Currency)
    func setDefaultValues()
    func swapCurrency()
    func fetchRates(fromCurrency: Currency, toCurrency: Currency, amount: Double, isSender: Bool)
}

final class CurrencyViewModel: CurrencyViewModelProtocol {
    
    private let networkService: NetworkServiceProtocol
    private let coordinator: Coordinator
    
    var onError: ((String, String) -> Void)?
    var onSenderAmountError: ((String) -> Void)?
    
    var onFetchRequest: (() -> Void)?
    
    var updateReceiverAmount: ((String) -> Void)?
    var updateSenderAmount: ((String) -> Void)?
    
    var updateRateText: ((String) -> Void)?
    var updateSenderCurrencyText: ((String) -> Void)?
    var updateSenderCurrencyImage: ((Currency) -> Void)?
    var updateReceiverCurrencyText: ((String) -> Void)?
    var updateReceiverCurrencyImage: ((Currency) -> Void)?
    
    private var senderCurrency: Currency = .PLN
    private var receiverCurrency: Currency = .UAH
    private var senderAmount: String = "300"
    private var receiverAmount: String = ""
    private var rate: Double = .zero
    
    init(networkService: NetworkServiceProtocol, coordinator: Coordinator) {
        self.networkService = networkService
        self.coordinator = coordinator
    }
    
    func fetchRates(fromCurrency: Currency, toCurrency: Currency, amount: Double, isSender: Bool) {
        onFetchRequest?()
        
        Logger.info("from: \(fromCurrency.rawValue) - to: \(toCurrency.rawValue) - amount: \(amount) - isSender: \(isSender)")
        
        Logger.info("sender: \(senderCurrency.rawValue) - to: \(receiverCurrency.rawValue) - SenderAmount: \(senderAmount) - ReceiverAmount: \(receiverAmount)")

        Logger.info("Request sended on vm")
        networkService.cancelTask()
        let request = CurrencyRateRequest(from: fromCurrency.rawValue, to: toCurrency.rawValue, amount: amount)
        networkService.execute(request) { [weak self] (result: Result<CurrencyRate, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                let convertedAmount = self.calculateConvertedAmount(requestAmount: amount, rate: response.rate)
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
                
                let rateText = getRateText(from: fromCurrency.rawValue, to: toCurrency.rawValue, rate: self.formatAmount(response.rate))
                self.updateRateText?(rateText)
                
            case .failure(let error):
                let errorMessage = self.getErrorMessage(for: error)
                let errorMessageTitle = self.getErrorMessageTitle(for: error)
                self.onError?(errorMessage, errorMessageTitle)
            }
        }
    }
    
// MARK: view model helper methods
    func getErrorMessage(for error: Error) -> String {
        if let networkError = error as? NetworkError {
            return networkError.description
        } else {
            return NetworkError.unknownError.description
        }
    }
    
    func getErrorMessageTitle(for error: Error) -> String {
        if let networkError = error as? NetworkError {
            return networkError.title
        } else {
            return NetworkError.unknownError.title
        }
    }
    
    func getRateText(from: String, to: String, rate: String) -> String {
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
    
    func validateAmount(_ amount: Double, for currency: Currency) -> Bool {
        guard let limit = Currency.limits[currency] else {
            return false
        }
        return amount <= limit
    }
    
    func sendSenderValidationError(for currency: Currency) {
        let errorPreText = "Maximum sending amount: "
        onSenderAmountError?(errorPreText + Currency.limitsString[currency]! + " " + currency.rawValue)
    }
    
    func checkCurrencyIsSame(new: Currency, old: Currency) -> Bool {
        return new == old
    }
    
    func getSelectableCurrencies(hiddenCurrency: Currency) -> [Currency] {
        return Currency.allCases.filter { $0 != hiddenCurrency }
    }
    
}

//MARK: - Public methods called from ViewController - set
extension CurrencyViewModel {

    // it is initial set from task
    func setDefaultValues() {
        senderCurrency = .PLN
        receiverCurrency = .UAH
        senderAmount = "300"
        receiverAmount = ""
        
        updateSenderAmount?(senderAmount)
        updateSenderCurrencyText?(senderCurrency.rawValue)
        updateSenderCurrencyImage?(senderCurrency)
        updateReceiverCurrencyText?(receiverCurrency.rawValue)
        updateReceiverCurrencyImage?(receiverCurrency)
        
        let amount = senderAmount.toDouble() ?? 300
        fetchRates(fromCurrency: senderCurrency, toCurrency: receiverCurrency, amount: amount, isSender: true)
    }
    
    func senderAmountUpdated(_ text: String?) {
        senderAmount = text ?? ""
        guard let amount = senderAmount.toDouble() else {
            Logger.warning("senderAmountUpdated conversion Error, \(text ?? "null")")
            networkService.cancelTask()
            self.updateReceiverAmount?("")
            return
        }
        
        guard validateAmount(amount, for: senderCurrency) else {
            networkService.cancelTask()
            sendSenderValidationError(for: senderCurrency)
            return
        }
        
        fetchRates(fromCurrency: senderCurrency, toCurrency: receiverCurrency, amount: amount, isSender: true)
    }
    
    func receiverAmountUpdated(_ text: String?) {
        receiverAmount = text ?? ""
        guard let amount = receiverAmount.toDouble() else {
            Logger.warning("receiverAmountUpdated conversion Error, \(text ?? "null")")
            networkService.cancelTask()
            self.updateSenderAmount?("")
            return
        }
        fetchRates(fromCurrency: receiverCurrency, toCurrency: senderCurrency, amount: amount, isSender: false)
    }
    
    func changeSenderCurrency(_ currency: Currency) {
        guard !checkCurrencyIsSame(new: currency, old: senderCurrency) else { return }
        let currencyText = currency.rawValue
        
        senderCurrency = currency
        
        updateSenderCurrencyText?(currencyText)
        updateSenderCurrencyImage?(currency)
        
        guard let amount = senderAmount.toDouble() else {
            Logger.warning("senderAmountUpdated change conversion Error, \(senderAmount)")
            networkService.cancelTask()
            self.updateSenderAmount?("")
            return
        }
        fetchRates(fromCurrency: senderCurrency, toCurrency: receiverCurrency, amount: amount, isSender: true)
    }
    
    func changeReceiverCurrency(_ currency: Currency) {
        guard !checkCurrencyIsSame(new: currency, old: receiverCurrency) else { return }
        let currencyText = currency.rawValue
        
        receiverCurrency = currency
        
        updateReceiverCurrencyText?(currencyText)
        updateReceiverCurrencyImage?(currency)
        
        guard let amount = receiverAmount.toDouble() else {
            Logger.warning("receiverAmountUpdated change conversion Error, \(receiverAmount)")
            networkService.cancelTask()
            self.updateReceiverAmount?("")
            return
        }
        fetchRates(fromCurrency: receiverCurrency, toCurrency: senderCurrency, amount: amount, isSender: false)
    }
    
    // NOTE: i am not sure, always requests from render
    // maybe holding last updated value then swap it then send request from there ??
    func swapCurrency() {
        // swap using tuples
        (senderCurrency, receiverCurrency) = (receiverCurrency, senderCurrency)
        
        
        updateSenderCurrencyText?(senderCurrency.rawValue)
        updateSenderCurrencyImage?(senderCurrency)
        updateReceiverCurrencyText?(receiverCurrency.rawValue)
        updateReceiverCurrencyImage?(receiverCurrency)

        updateSenderAmount?(receiverAmount)
        
        // send new request from sender !!
        senderAmountUpdated(receiverAmount)
    }
    
    // MARK:  - Coordinator communication
    func changeSenderCurrencyTapped() {
        let currencyList = getSelectableCurrencies(hiddenCurrency: receiverCurrency)
        coordinator.presentSelectionView(with: currencyList, isSender: true)
    }
    
    func changeReceiverCurrencyTapped() {
        let currencyList = getSelectableCurrencies(hiddenCurrency: senderCurrency)
        coordinator.presentSelectionView(with: currencyList, isSender: false)
    }
}

// MARK: - String extension
fileprivate extension String {
    func toDouble() -> Double? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        return formatter.number(from: self)?.doubleValue
    }
}
