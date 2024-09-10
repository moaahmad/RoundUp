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
    private(set) var id: String
    var amount: CurrencyAndAmount?
    var direction: TransactionDirection?
    var reference: String?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        amount = try container.decodeIfPresent(CurrencyAndAmount.self, forKey: .amount)
        direction = try container.decodeIfPresent(TransactionDirection.self, forKey: .direction)
        reference = try container.decodeIfPresent(String.self, forKey: .reference)
        id = UUID().uuidString
    }

    init(
        amount: CurrencyAndAmount? = nil,
        direction: TransactionDirection? = nil,
        reference: String? = nil
    ) {
        self.amount = amount
        self.direction = direction
        self.reference = reference
        self.id = UUID().uuidString
    }
}

extension FeedItem: Hashable & Equatable {
    static func == (lhs: FeedItem, rhs: FeedItem) -> Bool {
        lhs.id == rhs.id
    }
}

private extension FeedItem {
    enum CodingKeys: String, CodingKey {
        case amount
        case direction
        case reference
    }
}
