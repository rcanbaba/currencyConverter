//
//  currencyConverterTests.swift
//  currencyConverterTests
//
//  Created by Can Babaoğlu on 7.07.2024.
//

import XCTest
@testable import currencyConverter

final class CurrencyConverterTests: XCTestCase {
    
    var mockService: MockNetworkService!
    var mockCoordinator: MockCoordinator!
    var converterViewModel: CurrencyViewModelProtocol!

    override func setUpWithError() throws {
        mockService = MockNetworkService()
        mockCoordinator = MockCoordinator()
        converterViewModel = CurrencyViewModel(networkService: mockService, coordinator: mockCoordinator)
    }

    override func tearDownWithError() throws {
        mockService = nil
        converterViewModel = nil
        mockCoordinator = nil
    }
    
    func testFetchRatesSuccessFromSender() {
        let expectation = self.expectation(description: "Fetching rates should succeed from sender")
        
        let currencyResponse = CurrencyRate(from: "PLN", to: "UAH", rate: 7.23)
        mockService.mockResult = .success(currencyResponse)
        
        converterViewModel.updateReceiverAmount = { amountText in
            XCTAssertEqual(amountText, "2169")
            expectation.fulfill()
        }
        
        converterViewModel.updateSenderAmount = { amountText in
            XCTFail("Failed, sender updated !!")
        }
        
        converterViewModel.fetchRates(fromCurrency: .PLN, toCurrency: .UAH, amount: 300, isSender: true)
        
        waitForExpectations(timeout: 5)
    }
    
    func testFetchRatesSuccessFromReceiver() {
        let expectation = self.expectation(description: "Fetching rates should succeed from receiver")
        
        let currencyResponse = CurrencyRate(from: "PLN", to: "UAH", rate: 7.23)
        mockService.mockResult = .success(currencyResponse)
        
        converterViewModel.updateSenderAmount = { amountText in
            XCTAssertEqual(amountText, "2169")
            expectation.fulfill()
        }
        
        converterViewModel.updateReceiverAmount = { amountText in
            XCTFail("Failed, receiver updated !!")
        }
        
        converterViewModel.fetchRates(fromCurrency: .PLN, toCurrency: .UAH, amount: 300, isSender: false)
        
        waitForExpectations(timeout: 5)
    }
    
    func testFetchRatesFailure() {
        let expectation = self.expectation(description: "Fetching rates should fail")
        
        mockService.mockResult = .failure(NetworkError.networkRequestFailed)
        
        converterViewModel.onError = { errorMessage in
            XCTAssertEqual(errorMessage, NetworkError.networkRequestFailed.description)
            expectation.fulfill()
        }
        
        converterViewModel.fetchRates(fromCurrency: .PLN, toCurrency: .UAH, amount: 300, isSender: true)
        
        waitForExpectations(timeout: 5)
    }
    
    func testSetDefaultValues() {
        let expectation = self.expectation(description: "Default values should be set correctly")
        
        converterViewModel.updateSenderAmount = { amountText in
            XCTAssertEqual(amountText, "300")
            expectation.fulfill()
        }
        
        converterViewModel.setDefaultValues()
        
        waitForExpectations(timeout: 5)
    }
    
    func testSenderAmountValidation() {
        let expectation = self.expectation(description: "Sender amount validation should trigger error")
        
        converterViewModel.onSenderAmountError = { errorMessage in
            XCTAssertEqual(errorMessage, "Maximum sending amount: 20 000 PLN")
            expectation.fulfill()
        }
        
        converterViewModel.senderAmountUpdated("30000")
        
        waitForExpectations(timeout: 5)
    }
    
    func testSenderAmountValidationForGBP() {
        let currency = Currency.GBP
        let expectation = self.expectation(description: "GBP Sender amount validation should trigger error")
        
        converterViewModel.changeSenderCurrency(.GBP)
        
        converterViewModel.onSenderAmountError = { errorMessage in
            XCTAssertEqual(errorMessage, "Maximum sending amount: \(currency.maxAmountText) \(currency.rawValue)")
            expectation.fulfill()
        }
        
        converterViewModel.senderAmountUpdated("1500")
        
        waitForExpectations(timeout: 10)
    }
    
    func testChangeSenderCurrency() {
        converterViewModel.setDefaultValues()
        
        converterViewModel.updateSenderCurrencyText = { currencyText in
            XCTAssertEqual(currencyText, "EUR")
        }
        
        converterViewModel.changeSenderCurrency(.EUR)
    }
    
    func testChangeReceiverCurrency() {
        converterViewModel.setDefaultValues()
        
        converterViewModel.updateReceiverCurrencyText = { currencyText in
            XCTAssertEqual(currencyText, "EUR")
        }
        
        converterViewModel.changeReceiverCurrency(.EUR)
    }
    
    func testSwapCurrency() {
        converterViewModel.setDefaultValues()
        
        converterViewModel.updateSenderCurrencyText = { currencyText in
            XCTAssertEqual(currencyText, "UAH")
        }
        
        converterViewModel.updateReceiverCurrencyText = { currencyText in
            XCTAssertEqual(currencyText, "PLN")
        }
        
        converterViewModel.swapCurrency()
    }
    
    func testReceiverAmountUpdated() {
        let expectation = self.expectation(description: "Receiver amount update should trigger rate fetch")
        let viewModel = CurrencyViewModel(networkService: mockService, coordinator: mockCoordinator)
        
        let currencyResponse = CurrencyRate(from: "UAH", to: "PLN", rate: 0.03)
        mockService.mockResult = .success(currencyResponse)
        
        viewModel.updateSenderAmount = { amountText in
            XCTAssertEqual(amountText, "9", "Expected sender amount to be 9.00, got \(amountText)")
            expectation.fulfill()
        }
        
        viewModel.receiverAmountUpdated("300")
        
        waitForExpectations(timeout: 5)
    }
    
    func testReceiverAmountUpdatedWithBadInputFromTextfield() {
        let expectation = self.expectation(description: "Receiver amount update should return then clean sender amount")
        let viewModel = CurrencyViewModel(networkService: mockService, coordinator: mockCoordinator)
        let badInput = "000,,123"
        
        viewModel.updateSenderAmount = { amountText in
            XCTAssertEqual(amountText, "", "Expected sender amount to be empty, got \(amountText)")
            expectation.fulfill()
        }
        
        viewModel.receiverAmountUpdated(badInput)
        
        waitForExpectations(timeout: 5)
    }
    
    func testSenderAmountUpdatedWithBadInputFromTextfield() {
        let expectation = self.expectation(description: "Receiver amount update should return then clean sender amount")
        let viewModel = CurrencyViewModel(networkService: mockService, coordinator: mockCoordinator)
        let badInput = "000,,123"
        
        viewModel.updateReceiverAmount = { amountText in
            XCTAssertEqual(amountText, "", "Expected sender amount to be empty, got \(amountText)")
            expectation.fulfill()
        }
        
        viewModel.senderAmountUpdated(badInput)
        
        waitForExpectations(timeout: 5)
    }
    
    // MARK: Coordinator test
    func testChangeSenderCurrencyTapped() {
        converterViewModel.setDefaultValues()
        
        converterViewModel.changeSenderCurrencyTapped()
        
        XCTAssertTrue(mockCoordinator.currencySelectionPresented)
    }
    
    func testChangeReceiverCurrencyTapped() {
        converterViewModel.setDefaultValues()
        
        converterViewModel.changeReceiverCurrencyTapped()
        
        XCTAssertTrue(mockCoordinator.currencySelectionPresented)
    }
    
    // MARK: view model methods test
    func testDoubleToStringFormatter() {
        let viewModel = CurrencyViewModel(networkService: mockService, coordinator: mockCoordinator)
        
        let amount1 = 1234.567
        let formattedAmount1 = viewModel.formatAmount(amount1)
        XCTAssertEqual(formattedAmount1, "1234,57", "Formatting error: expected 1234.57, got \(formattedAmount1)")
        
        let amount2 = 9876.54321
        let formattedAmount2 = viewModel.formatAmount(amount2)
        XCTAssertEqual(formattedAmount2, "9876,54", "Formatting error: expected 9876.54, got \(formattedAmount2)")
        
        let amount3 = 100.0
        let formattedAmount3 = viewModel.formatAmount(amount3)
        XCTAssertEqual(formattedAmount3, "100", "Formatting error: expected 100.00, got \(formattedAmount3)")
        
        let amount4 = 0.0
        let formattedAmount4 = viewModel.formatAmount(amount4)
        XCTAssertEqual(formattedAmount4, "0", "Formatting error: expected 0.00, got \(formattedAmount4)")
        
        let amount5 = 1.2345
        let formattedAmount5 = viewModel.formatAmount(amount5)
        XCTAssertEqual(formattedAmount5, "1,23", "Formatting error: expected 1.23, got \(formattedAmount5)")
    }
    
    func testRateTextGeneration() {
        let viewModel = CurrencyViewModel(networkService: mockService, coordinator: mockCoordinator)
        let rateText = viewModel.getRateText(from: "PLN", to: "UAH", rate: "7.23")
        XCTAssertEqual(rateText, "1 PLN = 7.23 UAH")
    }
    
    func testErrorMessageGeneration() {
        let viewModel = CurrencyViewModel(networkService: mockService, coordinator: mockCoordinator)
        let errorMessage = viewModel.getErrorMessage(for: NetworkError.serverError(statusCode: 404))
        XCTAssertEqual(errorMessage, NetworkError.serverError(statusCode: 404).description)
    }
    
    func testGetErrorMessage_unknownError() {
        let viewModel = CurrencyViewModel(networkService: mockService, coordinator: mockCoordinator)
        let unknownError = NSError(domain: "", code: -1, userInfo: nil)
        let errorMessage = viewModel.getErrorMessage(for: unknownError)
        
        XCTAssertEqual(errorMessage, NetworkError.unknownError.description, "The error message should be for unknown error.")
    }
}

