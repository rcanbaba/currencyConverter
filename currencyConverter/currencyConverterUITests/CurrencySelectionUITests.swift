//
//  CurrencySelectionUITests.swift
//  currencyConverterUITests
//
//  Created by Can Babaoğlu on 9.07.2024.
//

import XCTest

final class CurrencySelectionUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDown() {
        app = nil
        super.tearDown()
    }
    
    func navigateToCurrencySelectionViewController() {
        let selectCurrencyButton = app.otherElements["CurrencySelectionStackView_tapView"].firstMatch
        XCTAssertTrue(selectCurrencyButton.exists, "Select Currency button should exist")
        selectCurrencyButton.tap()
    }
    
    func testCurrencySelectionUIElementsExist() {
        navigateToCurrencySelectionViewController()
        
        let titleLabel = app.staticTexts["Receiving from"]
        XCTAssertTrue(titleLabel.exists, "Receiving from Title label should exist")
        
        let searchBar = app.searchFields["CurrencySelectionViewController_searchTextField"]
        XCTAssertTrue(searchBar.exists, "Search bar should exist")
        
        let tableView = app.tables["CurrencySelectionViewController_tableView"]
        XCTAssertTrue(tableView.exists, "Table view should exist")
        
        let handleImageView = app.images["CurrencySelectionViewController_handleImageView"]
        XCTAssertTrue(handleImageView.exists, "image view should exist")
    }
    
    func testCurrencySelectionFilter() {
        navigateToCurrencySelectionViewController()
        
        let searchBar = app.searchFields["CurrencySelectionViewController_searchTextField"]
        let tableView = app.tables["CurrencySelectionViewController_tableView"]
        
        searchBar.tap()
        searchBar.typeText("Germany")
        
        let filteredCell = tableView.cells.staticTexts["Germany"]
        XCTAssertTrue(filteredCell.exists, "Filtered cell should exist")
    }
    
    func testCurrencySelectionSearch() {
        navigateToCurrencySelectionViewController()
        
        let searchBar = app.searchFields["CurrencySelectionViewController_searchTextField"]
        let tableView = app.tables["CurrencySelectionViewController_tableView"]
        
        searchBar.tap()
        searchBar.typeText("G")
        
        let filteredCell = tableView.cells.staticTexts["Germany"]
        XCTAssertTrue(filteredCell.exists, "Filtered cell should exist")
        
        let filteredCell2 = tableView.cells.staticTexts["Great Britain"]
        XCTAssertTrue(filteredCell2.exists, "Filtered cell should exist")
    }
    
    func testCurrencySelection_cellDidSelect() {
        navigateToCurrencySelectionViewController()
        
        let tableView = app.tables["CurrencySelectionViewController_tableView"]
        
        let firstCell = tableView.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.exists, "The first cell should exist")
        firstCell.tap()
        
        let backView = app.otherElements["ConverterViewController_view"]
        XCTAssertTrue(backView.exists, "Back view should exist after selecting a cell")
    }
    
}
