//
//  URLPool.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 06/09/2024.
//

import Foundation

struct URLPool {
    private enum Endpoint {
        case accounts
        case accountHolder
        case name
        case accountIdentifiers(accountUid: String)
        case balance(accountUid: String)
        case transactions(accountUid: String, categoryUid: String, changesSince: String)
        case allSavingsGoal(accountUid: String)
        case createSavingsGoal(accountUid: String)
        case topUpSavingsGoal(accountUid: String, savingsGoalUid: String, transferUid: String)

        var path: String {
            switch self {
            case .accounts:
                "/api/v2/accounts"
            case .accountHolder:
                "/api/v2/account-holder"
            case .name:
                "/api/v2/account-holder/name"
            case let .accountIdentifiers(accountUId):
                "/api/v2/accounts/\(accountUId)/identifiers"

            case let .balance(accountUid):
                "/api/v2/accounts/\(accountUid)/balance"
            case let .transactions(accountUid, categoryUid, changesSince):
                "/api/v2/feed/account/\(accountUid)/category/\(categoryUid)?changesSince=\(changesSince)"
            case let .allSavingsGoal(accountUid), let .createSavingsGoal(accountUid):
                "/api/v2/account/\(accountUid)/savings-goals"
            case let .topUpSavingsGoal(accountUid, savingsGoalUid, transferUid):
                "/api/v2/account/\(accountUid)/savings-goals/\(savingsGoalUid)/add-money/\(transferUid)"
            }
        }
    }

    static private let scheme = "https"
    static private let host = "api-sandbox.starlingbank.com"
}

// MARK: - Root URLs

extension URLPool: RootURLPooling {
    func accountsURL() -> URL {
        Self.configureURL(
            path: Endpoint.accounts.path
        )
    }
}

// MARK: - Home URLs

extension URLPool: HomeURLPooling {
    func accountHolderURL() -> URL {
        Self.configureURL(
            path: Endpoint.accountHolder.path
        )
    }

    func nameURL() -> URL {
        Self.configureURL(
            path: Endpoint.name.path
        )
    }

    func accountIdentifiersURL(accountUid: String) -> URL {
        Self.configureURL(
            path: Endpoint.accountIdentifiers(accountUid: accountUid).path
        )
    }

    func balanceURL(accountUid: String) -> URL {
        Self.configureURL(
            path: Endpoint.balance(accountUid: accountUid).path
        )
    }

    func transactionsURL(
        accountUid: String,
        categoryUid: String,
        changesSince: String
    ) -> URL {
        Self.configureURL(
            path: Endpoint.transactions(
                accountUid: accountUid,
                categoryUid: categoryUid,
                changesSince: changesSince
            ).path
        )
    }
}

// MARK: - Savings Goals URLs

extension URLPool: SavingsGoalsURLPooling {
    func allSavingsGoalsURL(accountUid: String) -> URL {
        Self.configureURL(
            path: Endpoint.allSavingsGoal(accountUid: accountUid).path
        )
    }

    func createSavingsGoalsURL(accountUid: String) -> URL {
        Self.configureURL(
            path: Endpoint.createSavingsGoal(accountUid: accountUid).path
        )
    }

    func topUpSavingsGoalURL(
        accountUid: String,
        savingsGoalUid: String,
        transferUid: String
    ) -> URL {
        Self.configureURL(
            path: Endpoint.topUpSavingsGoal(
                accountUid: accountUid,
                savingsGoalUid: savingsGoalUid,
                transferUid: transferUid
            ).path
        )
    }
}

// MARK: - Private Methods

private extension URLPool {
    static func configureURL(
        scheme: String = scheme,
        host: String = host,
        path: String,
        parameters: [URLQueryItem]? = nil
    ) -> URL {
        let urlComponents = configureURLComponents(
            scheme: scheme,
            host: host,
            path: path,
            parameters: parameters
        )
        guard let url = urlComponents.url,
              let urlString = url.absoluteString.removingPercentEncoding,
              let fullURL = URL(string: urlString) else {
            fatalError("URL is not correctly configured")
        }
        return fullURL
    }

    static func configureURLComponents(
        scheme: String,
        host: String,
        path: String,
        parameters: [URLQueryItem]?
    ) -> URLComponents {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = parameters
        return components
    }
}
