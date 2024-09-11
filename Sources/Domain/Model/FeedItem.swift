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
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return dateFormatter.date(from: transactionTime)
    }
}

extension FeedItem: Hashable & Equatable {
    static func == (lhs: FeedItem, rhs: FeedItem) -> Bool {
        lhs.feedItemUid == rhs.feedItemUid
    }
}
