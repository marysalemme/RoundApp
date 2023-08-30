//
//  MainCoordinator.swift
//  RoundApp
//
//  Created by Mary Salemme on 18/08/2023.
//

import Foundation
import UIKit

/// A protocol that all coordinators must conform to.
protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}

/// The main coordinator of the app.
class MainCoordinator: Coordinator {
    // MARK: - Properties
    
    /// The `UINavigationController` that the coordinator will use to push view controllers.
    var navigationController: UINavigationController
    
    /// The `StarlingRepository` that the coordinator will pass down to fetch data from the Starling API.
    var repository: StarlingRepositoryType
    
    // MARK: - Initializer
    
    /// Initialises the coordinator with a `UINavigationController` and a `StarlingRepository`.
    init(navigationController: UINavigationController,
         repository: StarlingRepositoryType) {
        self.navigationController = navigationController
        self.repository = repository
    }
    
    // MARK: - Coordinator
    
    func start() {
        showTransactions()
    }
    
    func showTransactions() {
        let transactionsViewModel = TransactionsViewModel(repository: repository)
        transactionsViewModel.coordinator = self
        let transactionsViewController = TransactionsViewController(viewModel: transactionsViewModel)
        navigationController.pushViewController(transactionsViewController, animated: false)
    }
    
    func addToSavings(amount: Int, for accountID: String) {
        let savingsViewModel = SavingsViewModel(roundUpAmount: amount, accountID: accountID, repository: repository)
        savingsViewModel.coordinator = self
        let savingsViewController = SavingsViewController(viewModel: savingsViewModel)
        navigationController.pushViewController(savingsViewController, animated: false)
    }
}
