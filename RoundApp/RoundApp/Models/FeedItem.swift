//
//  Transaction.swift
//  RoundApp
//
//  Created by Mary Salemme on 19/08/2023.
//

import Foundation

// MARK: - Transaction response
struct TransactionResponse: Codable {
    let feedItems: [FeedItem]
}

// MARK: - FeedItem
struct FeedItem: Codable {
    let feedItemUid: String
    let categoryUid: String
    let amount: Amount
    let direction: String
    let transactionTime: String
}

// MARK: - Amount
struct Amount: Codable {
    let currency: String
    let minorUnits: Int
}
