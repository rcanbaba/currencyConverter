//
//  CurrencySelectionTests.swift
//  currencyConverterTests
//
//  Created by Can Babaoğlu on 9.07.2024.
//

import XCTest
@testable import currencyConverter

final class CurrencySelectionTests: XCTestCase {

    var mockCoordinator: MockCoordinator!
    var viewModel: CurrencySelectionViewModelProtocol!
    var viewController: CurrencySelectionViewController!
    let mockCurrencies: [Currency] = [.PLN, .EUR, .GBP, .UAH]
    
    override func setUpWithError() throws {
        mockCoordinator = MockCoordinator()
        viewModel = CurrencySelectionViewModel(coordinator: mockCoordinator, currencies: mockCurrencies, isSender: true)
        viewController = CurrencySelectionViewController(viewModel: viewModel)
    }

    override func tearDownWithError() throws {
        mockCoordinator = nil
        viewModel = nil
    }
    
    func testInitializationFromSender() {
        XCTAssertEqual(viewModel.list.count, 4)
        XCTAssertEqual(viewModel.filteredCountries.count, 4)
        XCTAssertEqual(viewModel.titleText, "Receiving from")
    }

    func testFilterCountriesEmptyQuery() {
        viewModel.filterCountries(with: "")
        XCTAssertEqual(viewModel.filteredCountries.count, 4)
    }
    
    func testFilterCountriesWithQuery() {
        viewModel.filterCountries(with: "Germany")
        XCTAssertEqual(viewModel.filteredCountries.count, 1)
        XCTAssertEqual(viewModel.filteredCountries.first?.name, "Euro")
    }

    func testCurrencySelectedFromSender() {
        viewModel.currencySelected(with: .EUR)
        XCTAssertEqual(mockCoordinator.selectedCurrency, .EUR)
        XCTAssertEqual(mockCoordinator.isSender, true)
    }
    
    func testInitializationFromReceiver() {
        let viewModel = CurrencySelectionViewModel(coordinator: mockCoordinator, currencies: mockCurrencies, isSender: false)
        XCTAssertEqual(viewModel.list.count, 4)
        XCTAssertEqual(viewModel.filteredCountries.count, 4)
        XCTAssertEqual(viewModel.titleText, "Sending to")
    }
    
    func testCurrencySelectedFromReceiver() {
        let viewModel = CurrencySelectionViewModel(coordinator: mockCoordinator, currencies: mockCurrencies, isSender: false)
        viewModel.currencySelected(with: .EUR)
        XCTAssertEqual(mockCoordinator.selectedCurrency, .EUR)
        XCTAssertEqual(mockCoordinator.isSender, false)
    }

    func testTableViewRows() {
        let viewController = CurrencySelectionViewController(viewModel: viewModel)
        XCTAssertEqual(viewController.tableView.numberOfRows(inSection: 0), mockCurrencies.count)
    }
    
    func testFilteringCountries() {
        let expectation = self.expectation(description: "Countries should be filtered")
        
        viewModel.onCountriesFiltered = {
            expectation.fulfill()
        }
        
        viewController.searchBar(viewController.searchBar, textDidChange: "Germany")
        
        waitForExpectations(timeout: 1) { _ in
            XCTAssertEqual(self.viewModel.filteredCountries.count, 1)
            XCTAssertEqual(self.viewController.tableView.numberOfRows(inSection: 0), 1)
        }
    }
    
    func testSelectingCountry() {
        viewController.tableView(viewController.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        
        XCTAssertEqual(mockCoordinator.selectedCurrency, .PLN)
        XCTAssertEqual(mockCoordinator.isSender, true)
        XCTAssertEqual(mockCoordinator.returnedConverterView, true)
    }
}
