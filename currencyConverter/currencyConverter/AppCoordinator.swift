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
        let viewModel = CurrencyViewModel(currencyService: DependencyInjector.shared.provideCurrencyService())
        let viewController = ConverterViewController(viewModel: viewModel)
        viewController.delegate = self
        navigationController.pushViewController(viewController, animated: true)
    }
    
    // TODO: currency selection page will be implemented. !!
}

extension AppCoordinator: ConverterViewControllerDelegate {
    func currencySelectTapped(currentCurrency: Currency, isSender: Bool) {
        Logger.info("Coordinator: presentCurrencySelection")
        let viewModel = CurrencySelectionViewModel(currencies: [.EUR])
        let viewController = CurrencySelectionViewController(viewModel: viewModel)
        viewController.modalPresentationStyle = .formSheet
        viewController.delegate = self
        navigationController.present(viewController, animated: true, completion: nil)
    }
    
}

extension AppCoordinator: CurrencySelectionViewControllerDelegate {
    func currencySelected(currency: Currency, isSender: Bool) {
        Logger.info("Coordinator: currencySelected")
        navigationController.popViewController(animated: true)
    }
    
}
