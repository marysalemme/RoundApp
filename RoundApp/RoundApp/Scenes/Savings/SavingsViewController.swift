//
//  SavingsViewController.swift
//  RoundApp
//
//  Created by Mary Salemme on 27/08/2023.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxGesture
import SnapKit

class SavingsViewController: UIViewController {
    
    // MARK: - Subviews
    
    let noSavingGoalsView: ContainerView
    
    let noSavingGoalsText: UILabel
    
    let createNewGoalButton: UIButton
    
    let savingsGoalView: ContainerView
    
    let savingsGoalTitle: UILabel
    
    let savingsGoalTotalSaved: UILabel

    let savingsGoalTarget: UIProgressView
    
    // MARK: - Properties
    
    /// The `SavingsViewModel` that the view controller will use to fetch data from the Starling API.
    var viewModel: SavingsViewModel
    
    var disposeBag = DisposeBag()
    
    // MARK: - Initializer
    
    /// Initialises the view controller with a `SavingsViewModel`.
    ///
    /// - Parameter viewModel: The `SavingsViewModel` that the view controller will use to fetch data from the Starling API.
    init(viewModel: SavingsViewModel) {
        self.noSavingGoalsView = ContainerView(frame: .zero)
        self.noSavingGoalsText = UILabel(frame: .zero)
        self.createNewGoalButton = UIButton(frame: .zero)
        self.savingsGoalView = ContainerView(frame: .zero)
        self.savingsGoalTitle = UILabel(frame: .zero)
        self.savingsGoalTotalSaved = UILabel(frame: .zero)
        self.savingsGoalTarget = UIProgressView(progressViewStyle: .default)
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupUI()
        setupConstraints()
        setupBindings()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loadSavingGoals()
    }
    
    private func setupUI() {
        navigationController?.navigationBar.isTranslucent = false
        view.backgroundColor = .systemGray6
        view.addSubview(noSavingGoalsView)
        
        noSavingGoalsText.font = .preferredFont(forTextStyle: .title3)
        noSavingGoalsText.textAlignment = .center
        noSavingGoalsView.addSubview(noSavingGoalsText)
        
        createNewGoalButton.titleLabel?.font = .preferredFont(forTextStyle: .body)
        createNewGoalButton.setTitleColor(.systemGray, for: .normal)
        createNewGoalButton.backgroundColor = .systemBackground
        createNewGoalButton.layer.cornerRadius = 20
        noSavingGoalsView.addSubview(createNewGoalButton)
    
        view.addSubview(savingsGoalView)
        
        savingsGoalTitle.font = .preferredFont(forTextStyle: .title1)
        savingsGoalTitle.textAlignment = .center
        savingsGoalView.addSubview(savingsGoalTitle)
        
        savingsGoalTotalSaved.font = .preferredFont(forTextStyle: .title3)
        savingsGoalTotalSaved.textAlignment = .center
        savingsGoalView.addSubview(savingsGoalTotalSaved)
        
        savingsGoalView.addSubview(savingsGoalTarget)
    }
    
    private func setupConstraints() {
        noSavingGoalsView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
        }
        noSavingGoalsText.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(10)
        }
        createNewGoalButton.snp.makeConstraints { make in
            make.top.equalTo(noSavingGoalsText.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(20)
            make.height.greaterThanOrEqualTo(50)
        }
        savingsGoalView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
        }
        savingsGoalTitle.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(10)
        }
        savingsGoalTotalSaved.snp.makeConstraints { make in
            make.top.equalTo(savingsGoalTitle.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
        }
        savingsGoalTarget.snp.makeConstraints { make in
            make.top.equalTo(savingsGoalTotalSaved.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(20)
        }
    }
    
    private func setupBindings() {
        viewModel.screenTitle
            .drive(navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        viewModel.emptyViewText
            .drive(noSavingGoalsText.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.emptyViewButtonTitle
            .drive(createNewGoalButton.rx.title())
            .disposed(by: disposeBag)
        
        viewModel.showEmptyView
            .drive(onNext: { [weak self] showEmptyView in
                self?.savingsGoalView.isHidden = showEmptyView
                self?.noSavingGoalsView.isHidden = !showEmptyView
            })
            .disposed(by: disposeBag)
        
        viewModel.savingsGoalTitle
            .drive(savingsGoalTitle.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.savingsGoalTotalSaved
            .drive(savingsGoalTotalSaved.rx.text)
            .disposed(by: disposeBag)
        
        createNewGoalButton.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.createNewSavingGoal()
            })
            .disposed(by: disposeBag)
    }
}

