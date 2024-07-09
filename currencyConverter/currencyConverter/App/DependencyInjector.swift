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
    
    private var networkService: NetworkServiceProtocol
    private var appCoordinator: Coordinator
    private var navigationController: UINavigationController
    
    init() {
        networkService = NetworkService()
        navigationController = UINavigationController()
        appCoordinator = AppCoordinator(navigationController: navigationController)
    }

    
    func provideNetworkService() -> NetworkServiceProtocol {
        return networkService
    }
    
    func provideAppCoordinator() -> Coordinator {
        return appCoordinator
    }
    
    func provideNavigationController() -> UINavigationController {
        return navigationController
    }
}
