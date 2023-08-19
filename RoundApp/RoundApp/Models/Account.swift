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
    let accountUid: String
    let accountType: String
    let defaultCategory: String
    let currency: String
    let name: String
}
