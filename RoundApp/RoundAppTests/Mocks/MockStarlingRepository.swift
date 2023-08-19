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
                                   createdAt: "2023-08-18T11:37:14.893Z",
                                   name: "Personal"))
    }
    
    func getTransactions(accountID: String, categoryID: String, sinceDate: String) -> Single<[FeedItem]> {
        return Single.just([
            FeedItem(feedItemUid: "123", categoryUid: "123123", amount: Amount(currency: "GBP", minorUnits: 2300), direction: "OUT", transactionTime: "2023-08-18T16:37:14.893Z"),
            FeedItem(feedItemUid: "123", categoryUid: "123123", amount: Amount(currency: "GBP", minorUnits: 340), direction: "OUT", transactionTime: "2023-08-19T12:37:14.893Z")
        ])
    }
}
