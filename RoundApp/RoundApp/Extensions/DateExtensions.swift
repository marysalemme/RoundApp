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
    
    func getLastWeekDate() -> Date {
        return Calendar.current.date(byAdding: .day, value: -7, to: self)!
    }
    
    func formatToISO8601() -> String {
        let dateFormatter = ISO8601DateFormatter()
        return dateFormatter.string(from: self)
    }
}
