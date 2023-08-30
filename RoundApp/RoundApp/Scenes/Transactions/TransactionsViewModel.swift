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
    
    private let _showAddToSavingsButton = BehaviorRelay<Bool>(value: false)
    var showAddToSavingsButton: Driver<Bool> {
        return _showAddToSavingsButton.asDriver()
    }
    
    private let _transactions = BehaviorRelay<[FeedItem]>(value: [])
    var transactions: Driver<[FeedItem]> {
        return _transactions.asDriver()
    }
    
    // MARK: - Inputs
    
    func addToSavings() {
        guard let coordinator = coordinator,
                let roundUpAmount = roundUpAmount,
                let accountID = accountID else {
            assertionFailure("Coordinator, roundUpAmount and account ID should not be nil when add to savings button is enabled")
            return
        }
        coordinator.addToSavings(amount: roundUpAmount, for: accountID)
    }
    
    // MARK: - Dependencies
    
    /// The coordinator for the transactions scene.
    weak var coordinator: MainCoordinator?
    
    /// The repository used to fetch the transactions.
    private let repository: StarlingRepositoryType
    
    /// The account ID used to fetch the transactions.
    /// Required to navigate to the savings scene.
    private var accountID: String?
    
    /// The round up amount used to add to the savings goal.
    private var roundUpAmount: Decimal?

    /// The dispose bag for the view model. Used to dispose of any subscriptions.
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializer
    init(repository: StarlingRepositoryType) {
        self.repository = repository
    }
    
    func loadAccountTransactions() {
        // TODO: Add loading
        repository.getPrimaryAccount()
            .flatMap { account -> Single<[FeedItem]> in
                self._screenTitle.accept("\(account.name) Account")
                // TODO: Remove hardcoded date
                self.accountID = account.accountUid
                return self.repository.getTransactions(accountID: account.accountUid, categoryID: account.defaultCategory, sinceDate: "2023-08-18T11:37:14.893Z")
            }
            .subscribe { event in
                switch event {
                case .success(let transactions):
                    if transactions.isEmpty {
                        self._totalRoundUpAmount.accept("0 GBP")
                        self._showAddToSavingsButton.accept(false)
                        // TODO: Show empty state
                    } else {
                        self.roundUpAmount = self.calculateRoundUpAmount(transactions: transactions)
                        if let roundUpAmount = self.roundUpAmount, roundUpAmount != 0.00 {
                            self._totalRoundUpAmount.accept("\(roundUpAmount) GBP")
                            self._showAddToSavingsButton.accept(true)
                        } else {
                            self._totalRoundUpAmount.accept("0 GBP")
                            self._showAddToSavingsButton.accept(false)
                        }
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
