//
//  DateExtensions.swift
//  RoundApp
//
//  Created by Mary Salemme on 19/08/2023.
//

import Foundation

extension Date {
    func formatToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YY HH:mm"
        return dateFormatter.string(from: self)
    }
}
