//
//  AppState.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 10/09/2024.
//

import Combine

final class AppState: AppStateProviding {
    static let shared = AppState()

    var currentAccount = CurrentValueSubject<Account?, Error>(nil)

    private init() {}

    func updateAccount(with account: Account) {
        currentAccount.send(account)
    }

    func resetState() {
        currentAccount.value = nil
    }
}
