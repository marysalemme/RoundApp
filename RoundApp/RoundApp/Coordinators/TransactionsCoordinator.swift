//
//  TransactionsCoordinator.swift
//  RoundApp
//
//  Created by Mary Salemme on 20/08/2023.
//

import Foundation
import UIKit

class TransactionsCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    
    var repository: StarlingRepositoryType
    
    init(navigationController: UINavigationController,
         repository: StarlingRepositoryType) {
        self.navigationController = navigationController
        self.repository = repository
    }
    
    func start() {
        let transactionsViewModel = TransactionsViewModel(repository: repository)
        let transactionsViewController = TransactionsViewController(viewModel: transactionsViewModel)
        navigationController.pushViewController(transactionsViewController, animated: false)
    }
}
