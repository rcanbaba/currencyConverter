//
//  ViewController.swift
//  currencyConverter
//
//  Created by Can Babaoğlu on 7.07.2024.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.red
        
        let service = CurrencyService()
        
        print("Requested")
        service.fetchRates(from: "PLN", to: "UAH", amount: 10000) { [weak self] result in
            guard let self = self else { return }
            print("Response1")
            switch result {
            case .success(let rate):
                print("Success rate", rate.rate, rate.from, rate.to)
                
            case .failure(let error):
                print("Error", error.localizedDescription)
            }
        }
        
        service.cancelFetchRates()
        
        service.fetchRates(from: "UAH", to: "PLN", amount: 500) { [weak self] result in
            guard let self = self else { return }
            print("Response2")
            switch result {
            case .success(let rate):
                print("Success rate", rate.rate, rate.from, rate.to)
                
            case .failure(let error):
                print("Error", error.localizedDescription)
            }
        }
        
    }


}

