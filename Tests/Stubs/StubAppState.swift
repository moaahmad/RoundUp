//
//  StubAppState.swift
//  StarlingRoundUpTests
//
//  Created by Mo Ahmad on 12/09/2024.
//

import Foundation
import Combine
@testable import StarlingRoundUp

final class StubAppState: AppStateProviding {
    var currentAccount: CurrentValueSubject<Account?, Error> = .init(MockData.anyAccount())
    var updateAccountCalls: [Account] = []

    func updateAccount(with account: Account) {
        currentAccount.send(account)
        updateAccountCalls.append(account)
    }

    func resetState() {}
}

extension MockData {
    static func anyAccount(
        accountUid: String = UUID().uuidString,
        accountType: AccountType = .primary,
        defaultCategory: String = UUID().uuidString,
        currency: Currency = .gbp,
        createdAt: String = Date.now.description,
        name: String = anyUserName().accountHolderName
    ) -> Account {
        .init(
            accountUid: accountUid,
            accountType: accountType,
            defaultCategory: defaultCategory,
            currency: currency,
            createdAt: createdAt,
            name: name
        )
    }
}
