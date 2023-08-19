//
//  IntExtensions.swift
//  RoundApp
//
//  Created by Mary Salemme on 19/08/2023.
//

import Foundation

extension Int {
    func toDecimal() -> Decimal {
        return Decimal(integerLiteral: self) / Decimal(100)
    }
}

