//
//  AppCoordinator.swift
//  currencyConverter
//
//  Created by Can Babaoğlu on 7.07.2024.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}

class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = CurrencyViewModel(currencyService: CurrencyService())
        let viewController = ConverterViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    // TODO: currency selection page will be implemented. !!
}
