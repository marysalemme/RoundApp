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
    
    private let _roundUpSectionTitle = BehaviorRelay<String>(value: "Weekly Round Up Amount")
    var roundUpSectionTitle: Driver<String> {
        return _roundUpSectionTitle.asDriver()
    }
    
    private let _totalRoundUpAmount = BehaviorRelay<String>(value: "")
    var totalRoundUpAmount: Driver<String> {
        return _totalRoundUpAmount.asDriver()
    }
    
    private let _addToSavingsButtonTitle = BehaviorRelay<String>(value: "Add to Savings Goal")
    var addToSavingsButtonTitle: Driver<String> {
        return _addToSavingsButtonTitle.asDriver()
    }
    
    private let _transactions = BehaviorRelay<[FeedItem]>(value: [])
    var transactions: Driver<[FeedItem]> {
        return _transactions.asDriver()
    }
    
    // MARK: - Inputs
    
    func addToSavings() {
        print(coordinator)
        coordinator?.goToSavings()
    }
    
    // MARK: - Dependencies
    
    /// The coordinator for the transactions scene.
    weak var coordinator: MainCoordinator?
    
    /// The repository used to fetch the transactions.
    private let repository: StarlingRepositoryType
    
    /// The dispose bag for the view model. Used to dispose of any subscriptions.
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializer
    init(repository: StarlingRepositoryType) {
        self.repository = repository
//        loadAccountTransactions()
    }
    
    func loadAccountTransactions() {
        // TODO: Add loading
        repository.getPrimaryAccount()
            .flatMap { account -> Single<[FeedItem]> in
                self._screenTitle.accept("\(account.name) Account")
                // TODO: Remove hardcoded date
                return self.repository.getTransactions(accountID: account.accountUid, categoryID: account.defaultCategory, sinceDate: "2023-08-18T11:37:14.893Z")
            }
            .subscribe { event in
                switch event {
                case .success(let transactions):
                    if transactions.isEmpty {
                        self._totalRoundUpAmount.accept("0 GBP")
                        // TODO: Show empty state
                    } else {
                        let roundUpAmount = self.calculateRoundUpAmount(transactions: transactions)
                        self._totalRoundUpAmount.accept("\(roundUpAmount) GBP")
                    }
                    self._transactions.accept(transactions)
                case .failure(let error):
                    // TODO: Handle error
                    print(error)
                }
            }
            .disposed(by: disposeBag)
    }
    
    /// Method that calculates the round up amount for a list of transactions.
    /// The round up amount is the difference between the rounded up amount and the original amount.
    ///
    /// - Parameter transactions: The list of transactions
    /// - Returns: A decimal representing the round up amount
    private func calculateRoundUpAmount(transactions: [FeedItem]) -> Decimal {
        return transactions.reduce(0.00) { result, transaction -> Decimal in
            if transaction.direction == "OUT" {
                let transactionAmount = transaction.amount.minorUnits.toDecimal()
                return result + (transactionAmount.roundedUp() - transactionAmount)
            }
            return result
        }
    }
}
