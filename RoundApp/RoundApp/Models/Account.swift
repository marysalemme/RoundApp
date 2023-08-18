//
//  Account.swift
//  RoundApp
//
//  Created by Mary Salemme on 18/08/2023.
//

import Foundation

// MARK: - Response
struct Response: Codable {
    let accounts: [Account]
}

// MARK: - Account
struct Account: Codable {
    let accountUid, accountType, defaultCategory, currency: String
    let createdAt, name: String
}
