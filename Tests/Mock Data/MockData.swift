//
//  MockData.swift
//  StarlingRoundUpTests
//
//  Created by Mo Ahmad on 13/09/2024.
//

import Foundation
@testable import StarlingRoundUp

enum MockData {
    static func anyUserName(_ name: String = "Denis Irwin") -> UserName {
        .init(accountHolderName: name)
    }

    static func anyAccountHolder(
        accountHolderUid: String = "account-holder-uid",
        accountHolderType: AccountHolderType = .individual
    ) -> AccountHolder {
        .init(
            accountHolderUid: accountHolderUid,
            accountHolderType: accountHolderType
        )
    }

    static func anyAccountIdentifiers(
        accountIdentifier: String = "account-identifier",
        bankIdentifier: String = "001122"
    ) -> AccountIdentifiers {
        .init(
            accountIdentifier: accountIdentifier,
            bankIdentifier: bankIdentifier
        )
    }

    static func anyBalance(
        currency: Currency = .gbp,
        amount: Int64 = 10000
    ) -> Balance {
        .init(
            effectiveBalance: .init(
                currency: currency,
                minorUnits: amount
            )
        )
    }

    static func anyFeedItemsResponse() -> FeedItemsResponse {
        .init(
            feedItems: [
                .init(
                    feedItemUid: "123",
                    amount: .init(currency: .gbp, minorUnits: 10000),
                    direction: .paymentOut,
                    reference: "Test Reference 1",
                    transactionTime: Date.now.toISO8601String
                ),
                .init(
                    feedItemUid: "456",
                    amount: .init(currency: .gbp, minorUnits: 20000),
                    direction: .paymentOut,
                    reference: "Test Reference 2",
                    transactionTime: Date.now.toISO8601String
                ),
                .init(
                    feedItemUid: "789",
                    amount: .init(currency: .gbp, minorUnits: 30000),
                    direction: .paymentIn,
                    reference: "Test Reference 3",
                    transactionTime: Date.now.toISO8601String
                )
            ]
        )
    }
}
