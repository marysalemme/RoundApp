//
//  TransactionsViewModel.swift
//  RoundApp
//
//  Created by Mary Salemme on 18/08/2023.
//

import Foundation
import RxSwift
import RxCocoa

class TransactionsViewModel {

    // MARK: - Outputs
    
    private let _screenTitle = BehaviorRelay<String>(value: "")
    var screenTitle: Driver<String> {
        return _screenTitle.asDriver()
    }
    
    // MARK: - Dependencies
    
    var repository: StarlingRepositoryType
    
    /// The dispose bag for the view model. Used to dispose of any subscriptions.
    var disposeBag = DisposeBag()
    
    // MARK: - Initializer
    init(repository: StarlingRepositoryType) {
        self.repository = repository
        loadAccount()
    }
    
    func loadAccount() {
        repository.getPrimaryAccount()
            .subscribe { event in
                switch event {
                case .success(let account):
                    self._screenTitle.accept("\(account.name) Account")
                case .failure(let error):
                    // TODO: Handle error
                    print(error)
                }
            }
            .disposed(by: disposeBag)
    }
}
