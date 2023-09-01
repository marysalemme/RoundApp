//
//  Transaction.swift
//  RoundApp
//
//  Created by Mary Salemme on 19/08/2023.
//

import Foundation

struct TransactionResponse: Codable {
    let feedItems: [FeedItem]
}

struct FeedItem: Codable {
    let feedItemUid: String
    let categoryUid: String
    let amount: Amount
    let direction: String
    let transactionTime: Date
}

struct Amount: Codable {
    let currency: Currency
    let minorUnits: Int
}

enum Currency: String, Codable {
    case gbp = "GBP"
    case eur = "EUR"
    case usd = "USD"
    
    var symbol: String {
        switch self {
        case .gbp:
            return "£"
        case .eur:
            return "€"
        case .usd:
            return "$"
        }
    }
}

extension FeedItem {
    /// Custom initializer to parse a `FeedItem` from a decoder and get the transaction time as a `Date`.
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        feedItemUid = try container.decode(String.self, forKey: .feedItemUid)
        categoryUid = try container.decode(String.self, forKey: .categoryUid)
        amount = try container.decode(Amount.self, forKey: .amount)
        direction = try container.decode(String.self, forKey: .direction)

        let transactionTimeString = try container.decode(String.self, forKey: .transactionTime)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = dateFormatter.date(from: transactionTimeString) {
            transactionTime = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .transactionTime,
                                                   in: container,
                                                   debugDescription: "Date string does not match expected format")
        }
    }
}
