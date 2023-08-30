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
    
    private let _savingsGoalTarget = BehaviorRelay<String>(value: "")
    var savingsGoalTarget: Driver<String> {
        return _savingsGoalTarget.asDriver()
    }
    
    private let _savingsGoalTotalSaved = BehaviorRelay<String>(value: "")
    var savingsGoalTotalSaved: Driver<String> {
        return _savingsGoalTotalSaved.asDriver()
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
            .flatMap { savingGoalCreated -> Single<[SavingsGoal]> in
                return self.repository.getSavingGoals(accountID: self.accountID)
            }
            .subscribe { event in
                switch event {
                case .success(let savingGoals):
                    guard let savingGoal = savingGoals.first else { return }
                    self.setupSavingsGoalBindings(for: savingGoal)
                    self._showEmptyView.accept(false)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Dependencies
    
    weak var coordinator: MainCoordinator?
    
    private let repository: StarlingRepositoryType
    
    private let accountID: String
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializer
    init(accountID: String, repository: StarlingRepositoryType) {
        self.accountID = accountID
        self.repository = repository
    }
    
    func loadSavingGoals() {
        repository
            .getSavingGoals(accountID: accountID)
            .subscribe { event in
                switch event {
                case .success(let savingGoals):
                    if savingGoals.isEmpty {
                        self._showEmptyView.accept(true)
                    } else {
                        guard let savingGoal = savingGoals.first else { return }
                        self.setupSavingsGoalBindings(for: savingGoal)
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
