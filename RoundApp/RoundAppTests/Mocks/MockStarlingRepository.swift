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
}
