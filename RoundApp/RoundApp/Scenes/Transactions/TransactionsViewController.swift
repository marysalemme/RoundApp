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
import SnapKit

class TransactionsViewController: UIViewController {
    
    // MARK: - Properties
    
    let roundUpContainer: UIView
    
    let roundUpSectionTitle: UILabel
    
    let roundUpAmount: UILabel
    
    let tableView: UITableView
    
    var viewModel: TransactionsViewModel
    
    var disposeBag = DisposeBag()
    
    /// Initializes a `TransactionsViewController` with a `TransactionsViewModel`.
    init(viewModel: TransactionsViewModel) {
        self.roundUpContainer = UIView(frame: .zero)
        self.roundUpSectionTitle = UILabel(frame: .zero)
        self.roundUpAmount = UILabel(frame: .zero)
        self.tableView = UITableView(frame: .zero)
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupUI()
        setupConstraints()
        setupBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func setupUI() {
        navigationController?.navigationBar.isTranslucent = false
        view.backgroundColor = .systemGray6
        roundUpContainer.backgroundColor = .systemTeal
        roundUpContainer.layer.cornerRadius = 20
        view.addSubview(roundUpContainer)
        
        roundUpSectionTitle.font = .preferredFont(forTextStyle: .title3)
        roundUpSectionTitle.textAlignment = .center
        roundUpContainer.addSubview(roundUpSectionTitle)
        
        roundUpAmount.font = .preferredFont(forTextStyle: .title1)
        roundUpAmount.textAlignment = .center
        roundUpContainer.addSubview(roundUpAmount)
        
        tableView.backgroundColor = .systemGray6
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TransactionCell.self, forCellReuseIdentifier: "TransactionCell")
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.estimatedRowHeight = 120
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        roundUpContainer.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(150)
        }
        roundUpSectionTitle.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(10)
        }
        roundUpAmount.snp.makeConstraints { make in
            make.top.equalTo(roundUpSectionTitle.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(10)
//            make.bottom.equalToSuperview().inset(20)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(roundUpContainer.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func setupBindings() {
        viewModel.screenTitle
            .drive(navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        viewModel.roundUpSectionTitle
            .drive(roundUpSectionTitle.rx.text)
            .disposed(by: disposeBag)
        viewModel.totalRoundUpAmount
            .drive(roundUpAmount.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.transactions.drive(tableView.rx.items(cellIdentifier: TransactionCell.reuseIdentifier, cellType: TransactionCell.self)) { [weak self] _, transaction, cell in
            cell.amount = self?.composeTransactionString(amount: transaction.amount.minorUnits.toDecimal(), currency: transaction.amount.currency, direction: transaction.direction)
            cell.date = transaction.transactionTime.formatToString()
        }
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
