//
//  currencyConverterUITests.swift
//  currencyConverterUITests
//
//  Created by Can Babaoğlu on 7.07.2024.
//

import XCTest

final class currencyConverterUITests: XCTestCase {
    
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
    
    func testInitialUIElementsExist() {
        let senderTextFieldCustomView = app.otherElements["CurrencyConvertView_senderTextFieldView"]
        XCTAssertTrue(senderTextFieldCustomView.exists, "Sending amount text field should exist")
        
        let receiverTextFieldCustomView = app.otherElements["CurrencyConvertView_receiverTextFieldView"]
        XCTAssertTrue(receiverTextFieldCustomView.exists, "Receiver amount text field should exist")
        
        let swapButton = app.buttons["CurrencyConvertView_swapButton"]
        XCTAssertTrue(swapButton.exists, "Swap button should exist")
        
        let rateView = app.otherElements["RateView_view"]
        XCTAssertTrue(rateView.exists, "Rate view should exist")
        
        let senderTitle = app.staticTexts["Sending from"]
        XCTAssertTrue(senderTitle.exists, "senderTitle label should exist")
        
        let receiverTitle = app.staticTexts["Receiver gets"]
        XCTAssertTrue(receiverTitle.exists, "receiverTitle label should exist")
        
        let errorView = app.otherElements["BottomErrorView_view"]
        XCTAssertFalse(errorView.exists, "Error view should be hidden initially")
        
        let networkErrorView = app.otherElements["NetworkErrorView_view"]
        XCTAssertFalse(networkErrorView.exists, "Network error view should be hidden initially")
    }
    
    
    func testMaxAmountErrorDisplayed() {
        let senderTextFieldCustomView = app.otherElements["CurrencyConvertView_senderTextFieldView"]
        
        let textfield = senderTextFieldCustomView.textFields["TextFieldView_textField"]
        textfield.tap()
        textfield.typeText("280000")
        
        let errorView = app.otherElements["BottomErrorView_view"]
        XCTAssertTrue(errorView.exists, "Error view should be displayed for a large sending amount")
    }
    
    // TODO: generate more ui scenarios
}
