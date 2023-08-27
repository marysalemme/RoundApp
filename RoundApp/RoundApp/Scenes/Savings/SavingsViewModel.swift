//
//  SavingsViewModel.swift
//  RoundApp
//
//  Created by Mary Salemme on 27/08/2023.
//

import Foundation
import RxSwift
import RxCocoa

class SavingsViewModel {
    
    // MARK: - Dependencies
    
    weak var coordinator: MainCoordinator?
    
    private let repository: StarlingRepositoryType
    
    /// The dispose bag for the view model. Used to dispose of any subscriptions.
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializer
    init(repository: StarlingRepositoryType) {
        self.repository = repository
    }
}
