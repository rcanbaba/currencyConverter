//
//  DependencyInjector.swift
//  currencyConverter
//
//  Created by Can Babaoğlu on 7.07.2024.
//

import Foundation
import UIKit

class DependencyInjector {
    static let shared = DependencyInjector()
    
    private var currencyService: CurrencyServiceProtocol
    private var appCoordinator: Coordinator
    private var navigationController: UINavigationController
    
    init() {
        currencyService = CurrencyService()
        navigationController = UINavigationController()
        appCoordinator = AppCoordinator(navigationController: navigationController)
    }

    
    func provideCurrencyService() -> CurrencyServiceProtocol {
        return currencyService
    }
    
    func provideAppCoordinator() -> Coordinator {
        return appCoordinator
    }
    
    func provideNavigationController() -> UINavigationController {
        return navigationController
    }
}
