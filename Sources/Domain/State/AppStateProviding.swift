//
//  AppStateProviding.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 14/09/2024.
//

import Combine

protocol AppStateProviding {
    var currentAccount: CurrentValueSubject<Account?, Error> { get }

    func updateAccount(with account: Account)
    func resetState()
}
