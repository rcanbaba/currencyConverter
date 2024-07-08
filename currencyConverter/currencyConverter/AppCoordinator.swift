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
    func returnConverterView(with currency: Currency, isSender: Bool)
    func presentSelectionView(with currencyList: [Currency], isSender: Bool)
}

class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    var baseController: UIViewController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = CurrencyViewModel(
            currencyService: DependencyInjector.shared.provideCurrencyService(),
            coordinator: DependencyInjector.shared.provideAppCoordinator()
        )
        let viewController = ConverterViewController(viewModel: viewModel)
        baseController = viewController
        navigationController.pushViewController(viewController, animated: true)
    }

    func presentSelectionView(with currencyList: [Currency], isSender: Bool) {
        Logger.info("Coordinator: presentCurrencySelection")
        let viewModel = CurrencySelectionViewModel(
            coordinator: DependencyInjector.shared.provideAppCoordinator(),
            currencies: currencyList,
            isSender: isSender
        )
        let viewController = CurrencySelectionViewController(viewModel: viewModel)
        viewController.modalPresentationStyle = .formSheet
        navigationController.present(viewController, animated: true, completion: nil)
    }

    func returnConverterView(with currency: Currency, isSender: Bool) {
        Logger.info("Coordinator: currencySelected")
        guard let baseController = baseController as? ConverterViewController else { return }
        baseController.newCurrencySelected(currency: currency, fromSender: isSender)
    }

}
