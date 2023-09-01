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
    
    private let _showSavingsGoal = BehaviorRelay<Bool>(value: false)
    var showSavingsGoal: Driver<Bool> {
        return _showSavingsGoal.asDriver()
    }
    
    private let _roundUpAmount = BehaviorRelay<Int>(value: 0)
    var roundUpAmount: Driver<Int> {
        return _roundUpAmount.asDriver()
    }
    
    private let _showLoading = BehaviorRelay<Bool>(value: false)
    var showLoading: Driver<Bool> {
        return _showLoading.asDriver()
    }
    
    private let _showError = BehaviorRelay<Bool>(value: false)
    var showError: Driver<Bool> {
        return _showError.asDriver()
    }
    
    private let _errorMessage = BehaviorRelay<String?>(value: nil)
    var errorMessage: Driver<String?> {
        return _errorMessage.asDriver()
    }
    
    // MARK: - Inputs
    
    func createNewSavingsGoal() {
        _showLoading.accept(true)
        // TODO: NiceToHave - Remove hard coded creation and navigate to new screen to create saving goal
        let goal = SavingsGoal(savingsGoalUid: nil,
                               name: "Round Up",
                               currency: "GBP",
                               target: Target(currency: .gbp, minorUnits: 200000),
                               totalSaved: nil,
                               savedPercentage: nil,
                               state: nil)
        repository.createSavingGoal(accountID: accountID, goal: goal)
            .flatMap { goalCreated -> Single<SavingsGoal> in
                return self.repository.getSavingsGoal(accountID: self.accountID, savingsGoalID: goalCreated.savingsGoalUid)
            }
            .subscribe { event in
                switch event {
                case .success(let savingsGoal):
                    self.savingsGoalId = savingsGoal.savingsGoalUid
                    self.updateSavingsGoalBindings(for: savingsGoal)
                    self._showSavingsGoal.accept(true)
                    self._showEmptyView.accept(false)
                case .failure(let error):
                    self._showError.accept(true)
                    self._errorMessage.accept(ErrorManager.handleError(error: error))
                }
                self._showLoading.accept(false)
            }
            .disposed(by: disposeBag)
    }
    
    func addRoundUpMoney() {
        _showLoading.accept(true)
        guard let savingsGoalId = savingsGoalId else {
            assertionFailure("Attempted to add money to saving goal without a saving goal ID")
            return
        }
        let transferRequest = SavingsGoalTransferRequest(amount: Amount(currency: .gbp, minorUnits: _roundUpAmount.value))
        repository.addMoneyToSavingGoal(accountID: accountID, savingsGoalID: savingsGoalId, transferRequest: transferRequest)
            .flatMap { _ -> Single<SavingsGoal> in
                return self.repository.getSavingsGoal(accountID: self.accountID, savingsGoalID: savingsGoalId)
            }
            .subscribe { event in
                switch event {
                case .success(let savingsGoal):
                    self.updateSavingsGoalBindings(for: savingsGoal)
                    self._roundUpAmount.accept(0)
                    self._showSavingsGoal.accept(true)
                case .failure(let error):
                    self._showError.accept(true)
                    self._errorMessage.accept(ErrorManager.handleError(error: error))
                }
                self._showLoading.accept(false)
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Dependencies
    
    weak var coordinator: MainCoordinator?
    
    private let repository: StarlingRepositoryType
    
    private let accountID: String
    
    private let disposeBag = DisposeBag()
    
    private var savingsGoalId: String?
    
    // MARK: - Initializer
    init(roundUpAmount: Int, accountID: String, repository: StarlingRepositoryType) {
        self.accountID = accountID
        self.repository = repository
        self._roundUpAmount.accept(roundUpAmount)
    }
    
    func loadSavingGoals() {
        _showLoading.accept(true)
        repository
            .getSavingsGoals(accountID: accountID)
            .subscribe { event in
                switch event {
                case .success(let savingsGoals):
                    if savingsGoals.isEmpty {
                        self._showEmptyView.accept(true)
                    } else {
                        guard let savingsGoal = savingsGoals.first else { return }
                        self.updateSavingsGoalBindings(for: savingsGoal)
                        self.savingsGoalId = savingsGoal.savingsGoalUid
                        self._showSavingsGoal.accept(true)
                    }
                case .failure(let error):
                    self._showError.accept(true)
                    self._errorMessage.accept(ErrorManager.handleError(error: error))
                }
                self._showLoading.accept(false)
            }
            .disposed(by: disposeBag)
    }
    
    private func updateSavingsGoalBindings(for goal: SavingsGoal) {
        _savingsGoalTitle.accept(goal.name)
        _savingsGoalTotalSaved.accept("\(goal.target.currency.symbol)\(goal.totalSaved?.minorUnits.toDecimal() ?? 0.0)/\(goal.target.currency.symbol)\(goal.target.minorUnits.toDecimal())")
    }
}
