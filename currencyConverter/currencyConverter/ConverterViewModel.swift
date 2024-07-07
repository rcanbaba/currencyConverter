//
//  ConverterViewModel.swift
//  currencyConverter
//
//  Created by Can Babaoğlu on 7.07.2024.
//

import Foundation

protocol CurrencyViewModelProtocol {
    var onRatesFetched: ((CurrencyRate) -> Void)? { get set }
    var onError: ((Error) -> Void)? { get set }
    var onError2: ((String) -> Void)? { get set }
    
    var updateReceiverAmount: ((String) -> Void)? { get set }
    var updateSenderAmount: ((String) -> Void)? { get set }
    
    var updateRateText: ((String) -> Void)? { get set }
    

    func cancelFetchRates()
    func validateAmount(_ amount: Double, for currency: Currency) -> Bool
    func setFromCurrency(_ currency: Currency)
    func setToCurrency(_ currency: Currency)
    func senderAmountUpdated(_ text: String?)
    func receiverAmountUpdated(_ text: String?)
}


class CurrencyViewModel: CurrencyViewModelProtocol {
    private let currencyService: CurrencyServiceProtocol
    
    var onRatesFetched: ((CurrencyRate) -> Void)?
    var onError: ((Error) -> Void)?
    var onError2: ((String) -> Void)?
    var updateReceiverAmount: ((String) -> Void)?
    var updateSenderAmount: ((String) -> Void)?
    var updateRateText: ((String) -> Void)?
    
    private var senderCurrency: Currency = .PLN
    private var receiverCurrency: Currency = .UAH
    private var senderAmount: String = "300.000"
    private var receiverAmount: String = ""
    private var rate: Double = .zero
    
    init(currencyService: CurrencyServiceProtocol) {
        self.currencyService = currencyService
    }
    
    func fetchRates(fromCurrency: Currency, toCurrency: Currency, amount: Double, isSender: Bool) {
        
        print("from: \(fromCurrency.rawValue) - to: \(toCurrency.rawValue) - amount: \(amount) - isSender: \(isSender)")
        
        print("sender: \(senderCurrency.rawValue) - to: \(receiverCurrency.rawValue) - SenderAmount: \(senderAmount) - ReceiverAmount: \(receiverAmount)")
        
        // TODO: burda her zaman sender kontrol edilmeli, hata olursa return direkt
//        guard validateAmount(amount, for: fromCurrency) else {
//            onError2?("Amount exceeds limit for \(fromCurrency.rawValue)")
//            return
//        }
        print("Request sended")
        currencyService.fetchRates(from: fromCurrency.rawValue, to: toCurrency.rawValue, amount: amount) { [weak self] result in
            guard let self = self else { return }
            print("REsponsedd c")
            switch result {
            case .success(let rate):
                self.onRatesFetched?(rate)
                
                let convertedAmount = self.calculateConvertedAmount(requestAmount: amount, rate: rate.rate)
                let formattedAmount = self.formatAmount(convertedAmount)
                if isSender {
                    self.updateReceiverAmount?(formattedAmount)
                } else {
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
            print("ERROR conver11")
            return }
        fetchRates(fromCurrency: senderCurrency, toCurrency: receiverCurrency, amount: amount, isSender: true)
    }
    
    func receiverAmountUpdated(_ text: String?) {
        receiverAmount = text ?? ""
        guard let amount = receiverAmount.toDouble() else {
            print("ERROR conver22")
            return }
        fetchRates(fromCurrency: receiverCurrency, toCurrency: senderCurrency, amount: amount, isSender: false)
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
