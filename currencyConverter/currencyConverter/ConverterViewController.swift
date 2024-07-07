//
//  ConverterViewController.swift
//  currencyConverter
//
//  Created by Can Babaoğlu on 7.07.2024.
//

import UIKit

class ConverterViewController: UIViewController {
    
    
    private var viewModel: CurrencyViewModelProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.red
        
        viewModel = CurrencyViewModel(currencyService: CurrencyService())

        print("Requested")
        viewModel.onRatesFetched = { rate in
            // Update UI with fetched rates
            
            print("RATE: from: \(rate.from) - \(rate.rate) - \(rate.to)")

            
        }
        viewModel.onError = { error in
            // Handle error
            print("Errorr1231")

        }
        viewModel.onError2 = { errorMessage in
            
            print("Error Limit", errorMessage)
 
            
        }
        
    }


}

