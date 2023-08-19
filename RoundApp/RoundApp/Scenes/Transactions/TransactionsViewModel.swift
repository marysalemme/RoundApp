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
    
    private let _transactions = BehaviorRelay<[FeedItem]>(value: [])
    var transactions: Driver<[FeedItem]> {
        return _transactions.asDriver()
    }
    
    // MARK: - Dependencies
    
    var repository: StarlingRepositoryType
    
    /// The dispose bag for the view model. Used to dispose of any subscriptions.
    var disposeBag = DisposeBag()
    
    // MARK: - Initializer
    init(repository: StarlingRepositoryType) {
        self.repository = repository
        loadAccountTransactions()
    }
    
    func loadAccountTransactions() {
        // TODO: Add loading
        repository.getPrimaryAccount()
            .flatMap { account -> Single<[FeedItem]> in
                self._screenTitle.accept("\(account.name) Account")
                return self.repository.getTransactions(accountID: account.accountUid, categoryID: account.defaultCategory, sinceDate: "2023-08-18T11:37:14.893Z")
            }
            .subscribe { event in
                switch event {
                case .success(let transactions):
                    self._transactions.accept(transactions)
                    print(transactions)
                case .failure(let error):
                    // TODO: Handle error
                    print(error)
                }
            }
            .disposed(by: disposeBag)
    }
}
