//
//  TransactionCell.swift
//  RoundApp
//
//  Created by Mary Salemme on 19/08/2023.
//

import Foundation
import UIKit
import SnapKit
import RxSwift

class TransactionCell: UITableViewCell {
    
    public static let reuseIdentifier = "TransactionCell"

    private let cellView: UIView
    
    private let dateLabel: UILabel
    
    private let amountLabel: UILabel
    
    var amount: String? {
        didSet {
            self.amountLabel.text = amount
        }
    }

    var date: String? {
        didSet {
            self.dateLabel.text = date
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        cellView = UIView(frame: .zero)
        dateLabel = UILabel(frame: .zero)
        amountLabel = UILabel(frame: .zero)
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        selectionStyle = .none
        cellView.backgroundColor = .secondarySystemBackground
        cellView.layer.cornerRadius = 10
        cellView.clipsToBounds = true
        cellView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(cellView)
        
        dateLabel.font = .preferredFont(forTextStyle: .caption2)
        dateLabel.textColor = .systemTeal
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        cellView.addSubview(dateLabel)
        
        amountLabel.font = .preferredFont(forTextStyle: .body)
        amountLabel.textColor = .systemTeal
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        cellView.addSubview(amountLabel)
    }

    private func setupConstraints() {
        cellView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(10)
        }
        
        dateLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
        }
        
        amountLabel.snp.makeConstraints { (make) in
            make.top.equalTo(dateLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(20)
        }
    }
}

