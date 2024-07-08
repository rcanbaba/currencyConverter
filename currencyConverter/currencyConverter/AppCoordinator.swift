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
    var baseController: UIViewController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = CurrencyViewModel(currencyService: DependencyInjector.shared.provideCurrencyService())
        let viewController = ConverterViewController(viewModel: viewModel)
        baseController = viewController
        viewController.delegate = self
        navigationController.pushViewController(viewController, animated: true)
    }
}

//TODO: i am not sure this 1 to 1 implementation maybe 1 singleton manager hold states
extension AppCoordinator: ConverterViewControllerDelegate {
    func currencySelectTapped(currencyList: [Currency], isSender: Bool) {
        Logger.info("Coordinator: presentCurrencySelection")
        let viewModel = CurrencySelectionViewModel(currencies: currencyList, isSender: isSender)
        let viewController = CurrencySelectionViewController(viewModel: viewModel)
        viewController.modalPresentationStyle = .formSheet
        viewController.delegate = self
        navigationController.present(viewController, animated: true, completion: nil)
    }
    
}

extension AppCoordinator: CurrencySelectionViewControllerDelegate {
    func currencySelected(currency: Currency, isSender: Bool) {
        Logger.info("Coordinator: currencySelected")
        guard let baseController = baseController as? ConverterViewController else { return }
        baseController.newCurrencySelected(currency: currency, fromSender: isSender)
        
    }
    
}
