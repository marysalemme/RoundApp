//
//  TransactionsViewController.swift
//  RoundApp
//
//  Created by Mary Salemme on 18/08/2023.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxGesture
import SnapKit

class TransactionsViewController: UIViewController {
    
    // MARK: - Subviews
    
    let roundUpContainer: ContainerView
    
    let roundUpSectionTitle: UILabel
    
    let roundUpAmount: UILabel
    
    let addToSavingsButton: UIButton
    
    let tableView: UITableView
    
    var activityIndicator: UIActivityIndicatorView
    
    // MARK: - Properties
    
    var viewModel: TransactionsViewModel
    
    var disposeBag = DisposeBag()
    
    // MARK: - Initializers

    /// Initializes a `TransactionsViewController` with a `TransactionsViewModel`.
    init(viewModel: TransactionsViewModel) {
        self.roundUpContainer = ContainerView(frame: .zero)
        self.roundUpSectionTitle = UILabel(frame: .zero)
        self.roundUpAmount = UILabel(frame: .zero)
        self.addToSavingsButton = UIButton(frame: .zero)
        self.tableView = UITableView(frame: .zero)
        self.activityIndicator = UIActivityIndicatorView(style: .large)
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupUI()
        setupConstraints()
        setupBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View controller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loadAccountTransactions()
    }

    private func setupUI() {
        navigationController?.navigationBar.isTranslucent = false
        view.backgroundColor = .systemGray6
        view.addSubview(roundUpContainer)
        
        roundUpSectionTitle.font = .preferredFont(forTextStyle: .title3)
        roundUpSectionTitle.textAlignment = .center
        roundUpContainer.addSubview(roundUpSectionTitle)
        
        roundUpAmount.font = .preferredFont(forTextStyle: .title1)
        roundUpAmount.textAlignment = .center
        roundUpContainer.addSubview(roundUpAmount)
        
        addToSavingsButton.titleLabel?.font = .preferredFont(forTextStyle: .body)
        addToSavingsButton.setTitleColor(.systemGray, for: .normal)
        addToSavingsButton.backgroundColor = .systemBackground
        addToSavingsButton.layer.cornerRadius = 20
        roundUpContainer.addSubview(addToSavingsButton)
        
        tableView.backgroundColor = .systemGray6
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TransactionCell.self, forCellReuseIdentifier: "TransactionCell")
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.estimatedRowHeight = 120
        view.addSubview(tableView)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }
    
    private func setupConstraints() {
        roundUpContainer.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
        }
        roundUpSectionTitle.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(10)
        }
        if addToSavingsButton.isHidden {
            addToSavingsButton.snp.removeConstraints()
            roundUpAmount.snp.remakeConstraints { make in
                make.top.equalTo(roundUpSectionTitle.snp.bottom).offset(10)
                make.leading.equalToSuperview().offset(20)
                make.trailing.equalToSuperview().inset(10)
                make.bottom.equalToSuperview().inset(20)
            }
        } else {
            roundUpAmount.snp.remakeConstraints { make in
                make.top.equalTo(roundUpSectionTitle.snp.bottom).offset(10)
                make.leading.equalToSuperview().offset(20)
                make.trailing.equalToSuperview().inset(10)
            }
            addToSavingsButton.snp.remakeConstraints { make in
                make.top.equalTo(roundUpAmount.snp.bottom).offset(20)
                make.leading.equalToSuperview().offset(20)
                make.trailing.equalToSuperview().inset(20)
                make.bottom.equalToSuperview().inset(20)
                make.height.greaterThanOrEqualTo(50)
            }
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(roundUpContainer.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
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
        
        viewModel.roundUpSectionTitle
            .drive(roundUpSectionTitle.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.totalRoundUpAmount
            .drive(roundUpAmount.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.addToSavingsButtonTitle
            .drive(addToSavingsButton.rx.title())
            .disposed(by: disposeBag)
        
        viewModel.showRoundUpSection
            .drive(onNext: { [weak self] showButton in
                self?.roundUpContainer.isHidden = !showButton
                self?.setupConstraints()
            })
            .disposed(by: disposeBag)
        
        viewModel.transactions
            .drive(tableView.rx.items(cellIdentifier: TransactionCell.reuseIdentifier, cellType: TransactionCell.self)) { [weak self] _, transaction, cell in
                cell.amount = self?.composeTransactionString(amount: transaction.amount.minorUnits.toDecimal(), currency: transaction.amount.currency, direction: transaction.direction)
                cell.date = transaction.transactionTime.formatToString()
            }
            .disposed(by: disposeBag)
        
        viewModel.showLoading
            .drive(onNext: { [weak self] showLoading in
                showLoading ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
            })
            .disposed(by: disposeBag)
        
        // MARK: - Outputs
        
        addToSavingsButton.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.addToSavings()
            })
            .disposed(by: disposeBag)
    }
    
    private func composeTransactionString(amount: Decimal, currency: String, direction: String) -> String {
        if direction == "OUT" {
            return "- \(amount) \(currency.uppercased())"
        } else {
            return "+ \(amount) \(currency.uppercased())"
        }
    }
}
