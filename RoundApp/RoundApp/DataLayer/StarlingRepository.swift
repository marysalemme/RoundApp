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
    
    func getTransactions(accountID: String, categoryID: String, sinceDate: String) -> Single<[FeedItem]>
    
    func getSavingGoals(accountID: String) -> Single<[SavingsGoal]>
    
    func createSavingGoal(accountID: String, goal: SavingsGoal) -> Single<SavingsGoalCreated>
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
    
    /// Returns the transactions for the given account, category and date.
    func getTransactions(accountID: String, categoryID: String, sinceDate: String) -> Single<[FeedItem]> {
        return Single<[FeedItem]>.create { [unowned self] single in
            Task {
                do {
                    let feedItems = try await apiClient.getTransactions(accountID: accountID,
                                                                        categoryID: categoryID,
                                                                        sinceDate: sinceDate)
                    single(.success(feedItems))
                } catch {
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
    
    /// Returns the saving goals for the given account.
    func getSavingGoals(accountID: String) -> Single<[SavingsGoal]> {
        return Single<[SavingsGoal]>.create { [unowned self] single in
            Task {
                do {
                    let savingsGoals = try await apiClient.getSavingGoals(accountID: accountID)
                    single(.success(savingsGoals))
                } catch {
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
    
    /// Creates a saving goal for the given account with the given goal details.
    func createSavingGoal(accountID: String, goal: SavingsGoal) -> Single<SavingsGoalCreated> {
        return Single<SavingsGoalCreated>.create { [unowned self] single in
            Task {
                do {
                    let response = try await apiClient.createSavingGoal(accountID: accountID, goal: goal)
                    single(.success(response))
                } catch {
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
}
