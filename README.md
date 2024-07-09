## currencyConverter
transferGO task

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
- [ ] Add Font -> inter

- [ ] Block user interaction or add activity indicator -

- [ ] Network error handling

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
