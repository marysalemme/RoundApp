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
    
    let noTransactionsLabel: UILabel
    
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
        self.noTransactionsLabel = UILabel(frame: .zero)
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
        if roundUpContainer.isHidden {
            roundUpContainer.snp.removeConstraints()
            roundUpSectionTitle.snp.removeConstraints()
            addToSavingsButton.snp.removeConstraints()
            roundUpAmount.snp.removeConstraints()
            tableView.snp.remakeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(Sizes.smallMargin.value)
                make.horizontalEdges.equalToSuperview()
                make.bottom.equalToSuperview()
            }
        } else {
            roundUpContainer.snp.remakeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(Sizes.smallMargin.value)
                make.leading.equalToSuperview().offset(Sizes.mediumMargin.value)
                make.trailing.equalToSuperview().inset(Sizes.mediumMargin.value)
            }
            roundUpSectionTitle.snp.remakeConstraints { make in
                make.leading.top.equalToSuperview().offset(Sizes.mediumMargin.value)
                make.trailing.equalToSuperview().inset(Sizes.smallMargin.value)
            }
            roundUpAmount.snp.remakeConstraints { make in
                make.top.equalTo(roundUpSectionTitle.snp.bottom).offset(Sizes.smallMargin.value)
                make.leading.equalToSuperview().offset(Sizes.mediumMargin.value)
                make.trailing.equalToSuperview().inset(Sizes.smallMargin.value)
            }
            addToSavingsButton.snp.remakeConstraints { make in
                make.top.equalTo(roundUpAmount.snp.bottom).offset(Sizes.mediumMargin.value)
                make.leading.equalToSuperview().offset(Sizes.mediumMargin.value)
                make.trailing.equalToSuperview().inset(Sizes.mediumMargin.value)
                make.bottom.equalToSuperview().inset(Sizes.mediumMargin.value)
                make.height.greaterThanOrEqualTo(Sizes.buttonHeight.value)
            }
            tableView.snp.remakeConstraints { make in
                make.top.equalTo(roundUpContainer.snp.bottom).offset(Sizes.mediumMargin.value)
                make.leading.trailing.equalToSuperview()
                make.bottom.equalToSuperview()
            }
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
        
        viewModel.noTransactionsText
            .drive(noTransactionsLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.showNoTransactionsView
            .drive(onNext: { [weak self] showNoTransactionsView in
                if showNoTransactionsView {
                    self?.tableView.backgroundView = self?.noTransactionsLabel
                    self?.noTransactionsLabel.snp.makeConstraints { make in
                        make.centerX.equalToSuperview()
                        make.top.equalToSuperview()
                    }
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.transactions
            .drive(tableView.rx.items(cellIdentifier: TransactionCell.reuseIdentifier, cellType: TransactionCell.self)) { [weak self] _, transaction, cell in
                cell.amount = self?.composeTransactionString(amount: transaction.amount.minorUnits.toDecimal(), currency: transaction.amount.currency.symbol, direction: transaction.direction)
                cell.date = transaction.transactionTime.formatToString()
            }
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
        
        addToSavingsButton.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.addToSavings()
            })
            .disposed(by: disposeBag)
    }
    
    private func composeTransactionString(amount: Decimal, currency: String, direction: String) -> String {
        if direction == "OUT" {
            return "- \(currency)\(amount)"
        } else {
            return "+ \(currency)\(amount)"
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction  = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
