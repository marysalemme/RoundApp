//
//  MockStarlingRepository.swift
//  RoundAppTests
//
//  Created by Mary Salemme on 19/08/2023.
//

import Foundation
import RxSwift
@testable import RoundApp

class MockStarlingRepository: StarlingRepositoryType {
    
    func getPrimaryAccount() -> Single<Account> {
        return .just(Account(accountUid: "123",
                                   accountType: "PRIMARY",
                                   defaultCategory: "123123",
                                   currency: "GBP",
                                   name: "Personal"))
    }
    
    func getTransactions(accountID: String, categoryID: String, sinceDate: String) -> Single<[FeedItem]> {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return .just([
            FeedItem(feedItemUid: "123", categoryUid: "123123", amount: Amount(currency: .gbp, minorUnits: 2300), direction: "OUT", transactionTime:  dateFormatter.date(from: "2023-08-19T12:37:14.893Z")!), // round up amount: 0
            FeedItem(feedItemUid: "123", categoryUid: "123123", amount: Amount(currency: .gbp, minorUnits: 3425), direction: "OUT", transactionTime:  dateFormatter.date(from: "2023-08-19T12:37:14.893Z")!), // round up amount: 0.75
            FeedItem(feedItemUid: "123", categoryUid: "123123", amount: Amount(currency: .gbp, minorUnits: 123), direction: "OUT", transactionTime:  dateFormatter.date(from: "2023-08-19T12:37:14.893Z")!), // round up amount: 0.77
            FeedItem(feedItemUid: "123", categoryUid: "123123", amount: Amount(currency: .gbp, minorUnits: 56080), direction: "OUT", transactionTime:  dateFormatter.date(from: "2023-08-19T12:37:14.893Z")!), // round up amount: 0.2
            FeedItem(feedItemUid: "123", categoryUid: "123123", amount: Amount(currency: .gbp, minorUnits: 450500), direction: "IN", transactionTime:  dateFormatter.date(from: "2023-08-19T12:37:14.893Z")!)
        ])
    }
    
    func getSavingsGoals(accountID: String) -> Single<[SavingsGoal]> {
        return .just([SavingsGoal(savingsGoalUid: "123",
                                  name: "Round Up",
                                  currency: nil,
                                  target: Target(currency: .gbp, minorUnits: 200000),
                                  totalSaved: nil,
                                  savedPercentage: nil,
                                  state: "ACTIVE")])
    }
    
    func getSavingsGoal(accountID: String, savingsGoalID: String) -> Single<SavingsGoal> {
        return .just(SavingsGoal(savingsGoalUid: "123",
                                 name: "Round Up",
                                 currency: nil,
                                 target: Target(currency: .gbp, minorUnits: 200000),
                                 totalSaved: Target(currency: .gbp, minorUnits: 12000),
                                 savedPercentage: nil,
                                 state: "ACTIVE"))
    }
    
    func createSavingGoal(accountID: String, goal: SavingsGoal) -> Single<SavingsGoalCreated> {
        return .just(SavingsGoalCreated(savingsGoalUid: "123", success: true))
    }
    
    func addMoneyToSavingGoal(accountID: String,
                              savingsGoalID: String,
                              transferRequest: SavingsGoalTransferRequest) -> Single<SavingsGoalTransfer> {
        return .just(SavingsGoalTransfer(transferUid: "123", success: true))
    }
}

class MockStarlingRepositoryEmptyData: MockStarlingRepository {
    override func getTransactions(accountID: String, categoryID: String, sinceDate: String) -> Single<[FeedItem]> {
        return .just([])
    }
    
    override func getSavingsGoals(accountID: String) -> Single<[SavingsGoal]> {
        return .just([])
    }
    
    override func getSavingsGoal(accountID: String, savingsGoalID: String) -> Single<SavingsGoal> {
        return .just(SavingsGoal(savingsGoalUid: "123",
                                 name: "Round Up",
                                 currency: nil,
                                 target: Target(currency: .gbp, minorUnits: 200000),
                                 totalSaved: nil,
                                 savedPercentage: nil,
                                 state: "ACTIVE"))
    }
}

class MockStarlingRepositoryZeroRoundUp: MockStarlingRepository {
    override func getTransactions(accountID: String, categoryID: String, sinceDate: String) -> Single<[FeedItem]> {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return .just([FeedItem(feedItemUid: "123",
                               categoryUid: "123123",
                               amount: Amount(currency: .gbp, minorUnits: 2300),
                               direction: "OUT",
                               transactionTime:  dateFormatter.date(from: "2023-08-19T12:37:14.893Z")!)])
    }
}

class MockStarlingRepositoryAccountError: MockStarlingRepository {
    override func getPrimaryAccount() -> Single<Account> {
        return .error(RoundAppError.primaryAccountNotFound)
    }
}

class MockStarlingRepositoryTransactionsError: MockStarlingRepository {
    override func getTransactions(accountID: String, categoryID: String, sinceDate: String) -> Single<[FeedItem]> {
        return .error(RoundAppError.invalidResponse)
    }
}

class MockStarlingRepositoryGetSavingsGoalsError: MockStarlingRepository {
    override func getSavingsGoals(accountID: String) -> Single<[SavingsGoal]> {
        return .error(RoundAppError.invalidURL)
    }
}

class MockStarlingRepositoryGetSavingsGoalError: MockStarlingRepository {
    override func getSavingsGoal(accountID: String, savingsGoalID: String) -> Single<SavingsGoal> {
        return .error(RoundAppError.missingURL)
    }
}

class MockStarlingRepositoryCreateSavingsGoalError: MockStarlingRepository {
    override func createSavingGoal(accountID: String, goal: SavingsGoal) -> Single<SavingsGoalCreated> {
        return .error(RoundAppError.invalidBody)
    }
}

class MockStarlingRepositoryAddMoneyToSavingsGoalError: MockStarlingRepository {
    override func addMoneyToSavingGoal(accountID: String,
                              savingsGoalID: String,
                              transferRequest: SavingsGoalTransferRequest) -> Single<SavingsGoalTransfer> {
        return .error(RoundAppError.invalidData)
    }
}

