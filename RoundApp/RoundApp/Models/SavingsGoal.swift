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
    let savingsGoalUid: String?
    let name: String
    let currency: String?
    let target: Target
    let totalSaved: Target?
    let savedPercentage: Int?
    let state: String?
}

struct Target: Codable {
    let currency: String
    let minorUnits: Int
}

struct SavingsGoalCreated: Codable {
    let savingsGoalUid: String
    let success: Bool
}

struct SavingsGoalTransferRequest: Codable {
    let amount: Amount
}

struct SavingsGoalTransfer: Codable {
    let transferUid: String
    let success: Bool
}

