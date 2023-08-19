//
//  StarlingRepository.swift
//  RoundApp
//
//  Created by Mary Salemme on 18/08/2023.
//

import Foundation
import RxSwift

protocol StarlingRepositoryType {
    func getPrimaryAccount() -> Single<Account>
}

/// A repository that is used to fetch data from the Starling API.
class StarlingRepository: StarlingRepositoryType {
    
    /// The `StarlingAPIClientType` that will be used to make requests to the Starling API.
    let apiClient: StarlingAPIClientType
    
    /// Initialises the repository with a `StarlingAPIClientType`.
    init(apiClient: StarlingAPIClientType) {
        self.apiClient = apiClient
    }
    
    /// Returns the primary account for the user if there is one, or an error.
    func getPrimaryAccount() -> Single<Account> {
        return Single<Account>.create { [unowned self] single in
                Task {
                    do {
                        let accounts = try await apiClient.getAccounts()
                        if let account = accounts.first(where: { $0.accountType == "PRIMARY" }) {
                            single(.success(account))
                        } else {
                            single(.failure(StarlingError.primaryAccountNotFound))
                        }
                    } catch {
                        single(.failure(error))
                    }
                }
                return Disposables.create()
            }
    }
}