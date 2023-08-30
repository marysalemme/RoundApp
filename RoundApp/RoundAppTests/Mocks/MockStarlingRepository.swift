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
        return Single.just(Account(accountUid: "123",
                                   accountType: "PRIMARY",
                                   defaultCategory: "123123",
                                   currency: "GBP",
                                   name: "Personal"))
    }
    
    func getTransactions(accountID: String, categoryID: String, sinceDate: String) -> Single<[FeedItem]> {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return Single.just([
            FeedItem(feedItemUid: "123", categoryUid: "123123", amount: Amount(currency: "GBP", minorUnits: 2300), direction: "OUT", transactionTime:  dateFormatter.date(from: "2023-08-19T12:37:14.893Z")!), // round up amount: 0
            FeedItem(feedItemUid: "123", categoryUid: "123123", amount: Amount(currency: "GBP", minorUnits: 3425), direction: "OUT", transactionTime:  dateFormatter.date(from: "2023-08-19T12:37:14.893Z")!), // round up amount: 0.75
            FeedItem(feedItemUid: "123", categoryUid: "123123", amount: Amount(currency: "GBP", minorUnits: 123), direction: "OUT", transactionTime:  dateFormatter.date(from: "2023-08-19T12:37:14.893Z")!), // round up amount: 0.77
            FeedItem(feedItemUid: "123", categoryUid: "123123", amount: Amount(currency: "GBP", minorUnits: 56080), direction: "OUT", transactionTime:  dateFormatter.date(from: "2023-08-19T12:37:14.893Z")!), // round up amount: 0.2
            FeedItem(feedItemUid: "123", categoryUid: "123123", amount: Amount(currency: "GBP", minorUnits: 450500), direction: "IN", transactionTime:  dateFormatter.date(from: "2023-08-19T12:37:14.893Z")!)
        ])
    }
    
    func getSavingGoals(accountID: String) -> Single<[SavingsGoal]> {
        return .just([SavingsGoal(savingsGoalUid: "123",
                                  name: "Round Up",
                                  currency: nil,
                                  target: Target(currency: "GBP", minorUnits: 200000),
                                  totalSaved: nil,
                                  savedPercentage: nil,
                                  state: "ACTIVE")])
    }
    
    func createSavingGoal(accountID: String, goal: SavingsGoal) -> Single<SavingsGoalCreated> {
        return .just(SavingsGoalCreated(savingsGoalUid: "123", success: true))
    }
}

class MockStarlingRepositoryEmptyData: StarlingRepositoryType {
    func getPrimaryAccount() -> Single<Account> {
        return Single.just(Account(accountUid: "123",
                                   accountType: "PRIMARY",
                                   defaultCategory: "123123",
                                   currency: "GBP",
                                   name: "Personal"))
    }
    
    func getTransactions(accountID: String, categoryID: String, sinceDate: String) -> Single<[FeedItem]> {
        return Single.just([])
    }
    
    func getSavingGoals(accountID: String) -> Single<[SavingsGoal]> {
        return .just([])
    }
    
    func createSavingGoal(accountID: String, goal: SavingsGoal) -> Single<SavingsGoalCreated> {
        return .just(SavingsGoalCreated(savingsGoalUid: "123", success: true))
    }
}

class MockStarlingRepositoryZeroRoundUp: StarlingRepositoryType {
    func getPrimaryAccount() -> Single<Account> {
        return Single.just(Account(accountUid: "123",
                                   accountType: "PRIMARY",
                                   defaultCategory: "123123",
                                   currency: "GBP",
                                   name: "Personal"))
    }
    
    func getTransactions(accountID: String, categoryID: String, sinceDate: String) -> Single<[FeedItem]> {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return Single.just([FeedItem(feedItemUid: "123", categoryUid: "123123", amount: Amount(currency: "GBP", minorUnits: 2300), direction: "OUT", transactionTime:  dateFormatter.date(from: "2023-08-19T12:37:14.893Z")!)])
    }
    
    func getSavingGoals(accountID: String) -> Single<[SavingsGoal]> {
        return .just([])
    }
    
    func createSavingGoal(accountID: String, goal: SavingsGoal) -> Single<SavingsGoalCreated> {
        return .just(SavingsGoalCreated(savingsGoalUid: "123", success: true))
    }
}
