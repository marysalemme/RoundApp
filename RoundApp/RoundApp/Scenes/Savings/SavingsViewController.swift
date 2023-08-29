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
    
    let noSavingGoalsView: UIView
    
    let noSavingGoalsText: UILabel
    
    let createnewGoalButton: UIButton
    
    // MARK: - Properties
    
    /// The `SavingsViewModel` that the view controller will use to fetch data from the Starling API.
    var viewModel: SavingsViewModel
    
    var disposeBag = DisposeBag()
    
    // MARK: - Initializer
    
    /// Initialises the view controller with a `SavingsViewModel`.
    ///
    /// - Parameter viewModel: The `SavingsViewModel` that the view controller will use to fetch data from the Starling API.
    init(viewModel: SavingsViewModel) {
        self.noSavingGoalsView = UIView(frame: .zero)
        self.noSavingGoalsText = UILabel(frame: .zero)
        self.createnewGoalButton = UIButton(frame: .zero)
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
        noSavingGoalsView.backgroundColor = .systemTeal
        noSavingGoalsView.layer.cornerRadius = 20
        noSavingGoalsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(noSavingGoalsView)
        
        noSavingGoalsText.font = .preferredFont(forTextStyle: .title3)
        noSavingGoalsText.textAlignment = .center
        noSavingGoalsView.addSubview(noSavingGoalsText)
        
        createnewGoalButton.titleLabel?.font = .preferredFont(forTextStyle: .body)
        createnewGoalButton.setTitleColor(.systemGray, for: .normal)
        createnewGoalButton.backgroundColor = .systemBackground
        createnewGoalButton.layer.cornerRadius = 20
        noSavingGoalsView.addSubview(createnewGoalButton)
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
        createnewGoalButton.snp.makeConstraints { make in
            make.top.equalTo(noSavingGoalsText.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(20)
            make.height.greaterThanOrEqualTo(50)
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
            .drive(createnewGoalButton.rx.title())
            .disposed(by: disposeBag)
        
        viewModel.showEmptyView
            .drive(onNext: { [weak self] showEmptyView in
//                self?.tableView.isHidden = showEmptyView
                self?.noSavingGoalsView.isHidden = !showEmptyView
            })
            .disposed(by: disposeBag)
        
        createnewGoalButton.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.createNewSavingGoal()
            })
            .disposed(by: disposeBag)
    }
}

