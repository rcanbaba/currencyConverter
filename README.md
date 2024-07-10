## CurrencyConverter


# Overview
The Currency Converter app is an iOS application that allows users to convert currencies in real-time. The app features a user-friendly interface built using UIKit and SnapKit for layout constraints. It handles network requests to fetch exchange rates and displays appropriate error messages for various scenarios like network issues or validation errors.

# Setup Instructions

Just clone project from https://github.com/rcanbaba/currencyConverter and Snapkit library will be downloaded automatically by SPM.

-- SnapKit: Used for creating constraints programmatically. (considering time constraint, quick and efficient tool)

min deployment target: iOS 13.0

## Summary of the Solution
Implemented all specified cases from the task details.

- MVVM
- Programatic UI
- Coordinator, dependency injeciton
- Unit Tests
- UIUnit Tests

# Notes,

- Unit Tests coverage over %90
- UIUnit Tests tests implemented, can be improved.

<img width="937" alt="Ekran Resmi 2024-07-10 08 18 09" src="https://github.com/rcanbaba/currencyConverter/assets/32519328/8584017e-db3e-4ac9-b11e-2f0a08d27587">

- API Requests: Cancels old requests if a new one is made before the previous response is received. (can be improved using taskIdentifier)

- TextField Edge Cases: Handles edge cases like typing ",,,,,8383,334" or ",,,,".

- UI Implementation: Matches the provided Figma design exactly.

- Currency Selection: Does not show "local transfer" options if the user tries to send from the same currency to the same currency. (this currency not listed)

- Debug Logger: Implemented for development purposes.


# Own Notes

## Initial Plan

- [x] init new project, remove storyboard
- [x] MVVM architecture structure
- [x] Coordinator for currency page - currency selection page
- [x] Basic network service, then test
- Protocol oriented
- [x] Snapkit for speed up ui development
- [x] UI Components
 - rate view
 - textfield
 - curency selection view
 - ..
- [x] Converter feature implement
- [x] Currency selection feature implement
- [x] Swap feature implement
- [x] dependency injector
- [x] dependency injector
 
- [x] Unit test coverage > % 75
- [x] UI test
- [x] Search will be implemented
- [ ] If time is enough, search will be swiftui combine

- [ ] Localization for strings
- [x] Add Font -> inter

- [ ] Block user interaction or add activity indicator -

- [x] Network error handling

- [x] Textfield size bug fix
- [x] Error textfield border bug fix



## edge case notes

- [x] input check: ,,,,, or 10,,,, or 10,1,1,1,1, 

- [ ] decimal separator could be taken from local, dot or comma . , 

- [x] maximumFractionDigits 2,3 ? 
- [x] every input should be send api request 
- [x] if the api response not reached cancel api call
- [x] , or 0 not send api request, or limit values
- [x] in currency selection, other type should not be listed
- [x] in currency selection sender amount fixed ??
- [x] in swap sender amount fixed ??
- [ ] if user type , it should be 0, -> ,59595 meaningless instead of this make it 0,59595 it happens on live tgo app
- [ ] input check: 00000006 is meaningless make it 6 or 06 it happens on live tgo app
