//
//  SavingsViewModel.swift
//  RoundApp
//
//  Created by Mary Salemme on 27/08/2023.
//

import Foundation
import RxSwift
import RxCocoa

class SavingsViewModel {
    
    // MARK: - Outputs
    
    private let _screenTitle = BehaviorRelay<String>(value: "Saving Goals")
    var screenTitle: Driver<String> {
        return _screenTitle.asDriver()
    }
    
    private let _emptyViewText = BehaviorRelay<String>(value: "You have no saving goals")
    var emptyViewText: Driver<String> {
        return _emptyViewText.asDriver()
    }
    
    private let _showEmptyView = BehaviorRelay<Bool>(value: false)
    var showEmptyView: Driver<Bool> {
        return _showEmptyView.asDriver()
    }
    
    private let _emptyViewButtonTitle = BehaviorRelay<String>(value: "Create a new saving goal")
    var emptyViewButtonTitle: Driver<String> {
        return _emptyViewButtonTitle.asDriver()
    }
    
    private let _savingsGoalTitle = BehaviorRelay<String>(value: "")
    var savingsGoalTitle: Driver<String> {
        return _savingsGoalTitle.asDriver()
    }
    
    private let _savingsGoalTotalSaved = BehaviorRelay<String>(value: "")
    var savingsGoalTotalSaved: Driver<String> {
        return _savingsGoalTotalSaved.asDriver()
    }
    
    private let _addMoneyButtonTitle = BehaviorRelay<String>(value: "Add round up to Savings Goal")
    var addMoneyButtonTitle: Driver<String> {
        return _addMoneyButtonTitle.asDriver()
    }
    
    // MARK: - Inputs
    
    func createNewSavingGoal() {
        // TODO: NiceToHave - Remove hard coded creation and navigate to new screen to create saving goal
        let goal = SavingsGoal(savingsGoalUid: nil,
                               name: "Round Up",
                               currency: "GBP",
                               target: Target(currency: "GBP", minorUnits: 200000),
                               totalSaved: nil,
                               savedPercentage: nil,
                               state: nil)
        repository.createSavingGoal(accountID: accountID, goal: goal)
            .subscribe { event in
                switch event {
                case .success(let goalCreated):
                    self.savingsGoalId = goalCreated.savingsGoalUid
                case .failure(let error):
                    // Handle error
                    print(error)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func addRoundUpMoney() {
        guard let savingsGoalId = savingsGoalId else {
            assertionFailure("Attempted to add money to saving goal without a saving goal ID")
            return
        }
        let transferRequest = SavingsGoalTransferRequest(amount: Amount(currency: "GBP", minorUnits: roundUpAmount))
        repository.addMoneyToSavingGoal(accountID: accountID, savingsGoalID: savingsGoalId, transferRequest: transferRequest)
            .subscribe { event in
                switch event {
                case .success(let transfer):
                    print(transfer)
                case .failure(let error):
                    // Handle error
                    print(error)
                }
            }
            .disposed(by: disposeBag)
    
    }
    
    // MARK: - Dependencies
    
    weak var coordinator: MainCoordinator?
    
    private let repository: StarlingRepositoryType
    
    private let roundUpAmount: Int
    
    private let accountID: String
    
    private let disposeBag = DisposeBag()
    
    private var savingsGoalId: String?
    
    // MARK: - Initializer
    init(roundUpAmount: Int, accountID: String, repository: StarlingRepositoryType) {
        self.roundUpAmount = roundUpAmount
        self.accountID = accountID
        self.repository = repository
    }
    
    func loadSavingGoals() {
        repository
            .getSavingGoals(accountID: accountID)
            .subscribe { event in
                switch event {
                case .success(let savingsGoals):
                    if savingsGoals.isEmpty {
                        self._showEmptyView.accept(true)
                    } else {
                        guard let savingsGoal = savingsGoals.first else { return }
                        self.setupSavingsGoalBindings(for: savingsGoal)
                        self.savingsGoalId = savingsGoal.savingsGoalUid
                        self._showEmptyView.accept(false)
                    }
                case .failure(let error):
                    // TODO: Handle error
                    print(error)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func setupSavingsGoalBindings(for goal: SavingsGoal) {
        self._savingsGoalTitle.accept(goal.name)
        self._savingsGoalTotalSaved.accept("\(goal.target.currency) \(goal.totalSaved?.minorUnits.toDecimal() ?? 0.0)/\(goal.target.minorUnits.toDecimal())")
    }
}
