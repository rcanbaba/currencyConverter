## currencyConverter
transferGO task

# Initial Plan

- [ ] init new project, remove storyboard
- [ ] MVVM architecture structure
- [ ] Coordinator for currency page - currency selection page
- [ ] Basic network service, then tes
- Protocol oriented
- [ ] Snapkit for speed up ui development
- [ ] UI Components
 - rate view
 - textfield
 - curency selection view
 - ..
 
- [ ] Unit test
- [ ] UI test
- [ ] Search will be implemented
- [ ] If time is enough, search will be swiftui combine



# edge case notes
- [x] input check: ,,,,, or 10,,,, or 10,1,1,1,1, 

- [ ] decimal separator could be taken from local, dot or comma . , 

- [x] maximumFractionDigits 2,3 ? 
- [x] every input should be send api request 
- [x] if the api response not reached cancel api call
- [ ] , or 0 not send api request, or limit values
- [ ] in currency selection, other type should not be listed
- [ ] in currency selection sender amount fixed ??
- [ ] in swap sender amount fixed ??
- [ ] if user type , it should be 0, -> ,59595 meaningless instead of this make it 0,59595 it happens on live tgo app
- [ ] input check: 00000006 is meaningless make it 6 or 06 it happens on live tgo app
