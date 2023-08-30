//
//  ContainerView.swift
//  RoundApp
//
//  Created by Mary Salemme on 29/08/2023.
//

import Foundation
import UIKit

/// A view that represents a container with rounded corners and teal background.
class ContainerView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.backgroundColor = .systemTeal
        self.layer.cornerRadius = 20
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
