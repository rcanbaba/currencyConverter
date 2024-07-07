## currencyConverter
transferGO task

# Initial Plan

- init new project without storyboard
- MVVM architecture
- Coordinator for currency page - currency selection page
- Basic network service
- Protocol oriented
- Snapkit for quick ui development
- UI Components
- Unit test
- UI test
- Search will be implemented
- If time is enough, search will be swiftui combine



# edge case notes
- input check: ,,,,, or 10,,,, or 10,1,1,1,1, 
- decimal separator could be taken from local, dot or comma . , 
- maximumFractionDigits 2,3 ? 
- every input should be send api request 
- if the api response not reached cancel api call
- , or 0 not send api request, or limit values
