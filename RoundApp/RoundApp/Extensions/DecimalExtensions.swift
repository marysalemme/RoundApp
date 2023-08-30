//
//  DecimalExtensions.swift
//  RoundApp
//
//  Created by Mary Salemme on 20/08/2023.
//

import Foundation

extension Decimal {
    func roundedUp() -> Decimal {
        var rounded = Decimal()
        var decimal = self
        NSDecimalRound(&rounded, &decimal, 0, .up)
        return rounded
    }
    
    func toInt() -> Int {
        return NSDecimalNumber(decimal: self).intValue
    }
}
