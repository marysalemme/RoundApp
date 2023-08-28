//
//  SavingsGoal.swift
//  RoundApp
//
//  Created by Mary Salemme on 28/08/2023.
//

import Foundation

struct SavingsGoalsResponse: Codable {
    let savingsGoalList: [SavingsGoal]
}

struct SavingsGoal: Codable {
    let savingsGoalUid: String
    let name: String
    let target: Target
    let totalSaved: Target
    let savedPercentage: Int
    let state: String
}

struct Target: Codable {
    let currency: String
    let minorUnits: Int
}
