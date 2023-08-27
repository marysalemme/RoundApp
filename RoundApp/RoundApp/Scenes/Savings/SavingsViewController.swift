//
//  SavingsViewController.swift
//  RoundApp
//
//  Created by Mary Salemme on 27/08/2023.
//

import Foundation
import UIKit

class SavingsViewController: UIViewController {
    
    // MARK: - Properties
    
    /// The `SavingsViewModel` that the view controller will use to fetch data from the Starling API.
    var viewModel: SavingsViewModel
    
    // MARK: - Initializer
    
    /// Initialises the view controller with a `SavingsViewModel`.
    ///
    /// - Parameter viewModel: The `SavingsViewModel` that the view controller will use to fetch data from the Starling API.
    init(viewModel: SavingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Savings"
    }
    
    private func setupUI() {
        navigationController?.navigationBar.isTranslucent = false
        view.backgroundColor = .systemGray6
    }
}

