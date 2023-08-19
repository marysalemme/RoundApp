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
            FeedItem(feedItemUid: "123", categoryUid: "123123", amount: Amount(currency: "GBP", minorUnits: 2300), direction: "OUT", transactionTime:  dateFormatter.date(from: "2023-08-19T12:37:14.893Z")!),
            FeedItem(feedItemUid: "123", categoryUid: "123123", amount: Amount(currency: "GBP", minorUnits: 340), direction: "OUT", transactionTime:  dateFormatter.date(from: "2023-08-19T12:37:14.893Z")!)
        ])
    }
}
