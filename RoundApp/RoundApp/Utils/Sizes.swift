//
//  Sizes.swift
//  RoundApp
//
//  Created by Mary Salemme on 01/09/2023.
//

import Foundation

enum Sizes {
    case buttonHeight
    case smallMargin
    case mediumMargin
    case cornerRadius
    
    var value: CGFloat {
        switch self {
        case .buttonHeight:
            return 50
        case .smallMargin:
            return 8
        case .mediumMargin:
            return 16
        case .cornerRadius:
            return 20
        }
    }
}
