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

    let addMoneyButton: UIButton
    
    var activityIndicator: UIActivityIndicatorView
    
    // MARK: - Properties
    
    /// The `SavingsViewModel` that the view controller will use to fetch data from the Starling API.
    var viewModel: SavingsViewModel
    
    var disposeBag = DisposeBag()
    
    // MARK: - Initializers
    
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
        self.addMoneyButton = UIButton(frame: .zero)
        self.activityIndicator = UIActivityIndicatorView(style: .large)
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
        createNewGoalButton.layer.cornerRadius = Sizes.cornerRadius.value
        noSavingGoalsView.addSubview(createNewGoalButton)
    
        view.addSubview(savingsGoalView)
        
        savingsGoalTitle.font = .preferredFont(forTextStyle: .title1)
        savingsGoalTitle.textAlignment = .center
        savingsGoalView.addSubview(savingsGoalTitle)
        
        savingsGoalTotalSaved.font = .preferredFont(forTextStyle: .title3)
        savingsGoalTotalSaved.textAlignment = .center
        savingsGoalView.addSubview(savingsGoalTotalSaved)
        
        addMoneyButton.titleLabel?.font = .preferredFont(forTextStyle: .body)
        addMoneyButton.setTitleColor(.systemGray, for: .normal)
        addMoneyButton.backgroundColor = .systemBackground
        addMoneyButton.layer.cornerRadius = Sizes.cornerRadius.value
        savingsGoalView.addSubview(addMoneyButton)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }
    
    private func setupConstraints() {
        noSavingGoalsView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(Sizes.smallMargin.value)
            make.leading.equalToSuperview().offset(Sizes.mediumMargin.value)
            make.trailing.equalToSuperview().inset(Sizes.mediumMargin.value)
        }
        noSavingGoalsText.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(Sizes.mediumMargin.value)
            make.trailing.equalToSuperview().inset(Sizes.smallMargin.value)
        }
        createNewGoalButton.snp.makeConstraints { make in
            make.top.equalTo(noSavingGoalsText.snp.bottom).offset(Sizes.mediumMargin.value)
            make.leading.equalToSuperview().offset(Sizes.mediumMargin.value)
            make.trailing.equalToSuperview().inset(Sizes.mediumMargin.value)
            make.bottom.equalToSuperview().inset(Sizes.mediumMargin.value)
            make.height.greaterThanOrEqualTo(Sizes.buttonHeight.value)
        }
        savingsGoalView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(Sizes.smallMargin.value)
            make.leading.equalToSuperview().offset(Sizes.mediumMargin.value)
            make.trailing.equalToSuperview().inset(Sizes.mediumMargin.value)
        }
        savingsGoalTitle.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(Sizes.mediumMargin.value)
            make.trailing.equalToSuperview().inset(Sizes.smallMargin.value)
        }
        savingsGoalTotalSaved.snp.makeConstraints { make in
            make.top.equalTo(savingsGoalTitle.snp.bottom).offset(Sizes.mediumMargin.value)
            make.leading.equalToSuperview().offset(Sizes.mediumMargin.value)
            make.trailing.equalToSuperview().inset(Sizes.mediumMargin.value)
        }
        addMoneyButton.snp.makeConstraints { make in
            make.top.equalTo(savingsGoalTotalSaved.snp.bottom).offset(Sizes.mediumMargin.value)
            make.leading.equalToSuperview().offset(Sizes.mediumMargin.value)
            make.trailing.equalToSuperview().inset(Sizes.mediumMargin.value)
            make.bottom.equalToSuperview().inset(Sizes.mediumMargin.value)
            make.height.greaterThanOrEqualTo(Sizes.buttonHeight.value)
        }
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func setupBindings() {
        
        // MARK: - Inputs

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
                self?.noSavingGoalsView.isHidden = !showEmptyView
                self?.savingsGoalView.isHidden = showEmptyView
            })
            .disposed(by: disposeBag)
        
        viewModel.showSavingsGoal
            .drive(onNext: { [weak self] showSavingsGoal in
                self?.savingsGoalView.isHidden = !showSavingsGoal
                self?.noSavingGoalsView.isHidden = showSavingsGoal
            })
            .disposed(by: disposeBag)
        
        viewModel.savingsGoalTitle
            .drive(savingsGoalTitle.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.savingsGoalTotalSaved
            .drive(savingsGoalTotalSaved.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.addMoneyButtonTitle
            .drive(addMoneyButton.rx.title())
            .disposed(by: disposeBag)
        
        viewModel.showLoading
            .drive(onNext: { [weak self] showLoading in
                showLoading ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
            })
            .disposed(by: disposeBag)
        
        Observable.combineLatest(viewModel.showError.asObservable(), viewModel.errorMessage.asObservable())
            .subscribe { [weak self] showError, errorMessage in
                if showError, let errorMessage = errorMessage {
                    self?.showAlert(title: "Error", message: errorMessage)
                }
            }
            .disposed(by: disposeBag)
        
        // MARK: - Outputs
        
        createNewGoalButton.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.createNewSavingsGoal()
            })
            .disposed(by: disposeBag)
        
        addMoneyButton.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.addRoundUpMoney()
            })
            .disposed(by: disposeBag)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction  = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

