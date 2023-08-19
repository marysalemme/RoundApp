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
    
    /// Starts the coordinator's flow from the transactions screen.
    func start() {
        let transactionsViewModel = TransactionsViewModel(repository: repository)
        let transactionsViewController = TransactionsViewController(viewModel: transactionsViewModel)
        navigationController.pushViewController(transactionsViewController, animated: false)
    }
}
