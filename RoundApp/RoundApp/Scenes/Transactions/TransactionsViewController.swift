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
    
    let tableView = UITableView()
    
    var viewModel: TransactionsViewModel
    
    var disposeBag = DisposeBag()
    
    /// Initializes a `TransactionsViewController` with a `TransactionsViewModel`.
    init(viewModel: TransactionsViewModel) {
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
        view.backgroundColor = .systemGray6
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TransactionCell.self, forCellReuseIdentifier: "TransactionCell")
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 120
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupBindings() {
        viewModel.screenTitle
            .drive(navigationItem.rx.title)
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
