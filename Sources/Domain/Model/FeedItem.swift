//
//  FeedItem.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 10/09/2024.
//

import Foundation

struct FeedItemsResponse: Decodable {
    let feedItems: [FeedItem]
}

struct FeedItem: Decodable {
    typealias DateTime = String

    let feedItemUid: String
    var amount: CurrencyAndAmount?
    var direction: TransactionDirection?
    var reference: String?
    var transactionTime: DateTime?
}

extension FeedItem {
    var transactionDate: Date? {
        guard let transactionTime = transactionTime else {
            return nil
        }
        return Date.fromISO8601String(transactionTime)
    }
}

extension FeedItem: Hashable & Equatable {
    static func == (lhs: FeedItem, rhs: FeedItem) -> Bool {
        lhs.feedItemUid == rhs.feedItemUid
    }
}
