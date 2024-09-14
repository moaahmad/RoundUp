//
//  RootServicing.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 14/09/2024.
//

import Combine

protocol RootServicing {
    func fetchAccounts() -> Future<AccountsResponse, Error>
}
