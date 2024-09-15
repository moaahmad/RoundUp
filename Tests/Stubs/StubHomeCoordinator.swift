//
//  StubHomeCoordinator.swift
//  StarlingRoundUpTests
//
//  Created by Mo Ahmad on 12/09/2024.
//

import UIKit
@testable import StarlingRoundUp

final class StubHomeCoordinator: HomeCoordinating {
    var rootController: UIViewController?
    var client: HTTPClient

    var startCallsCount = 0
    var presentRoundedUpViewControllerCallsCount = 0

    init(
        rootController: UIViewController? = nil,
        client: HTTPClient = HTTPClientSpy()
    ) {
        self.rootController = rootController
        self.client = client
    }

    func start() {
        startCallsCount += 1
    }

    func presentRoundedUpViewController(
        balance: CurrencyAndAmount,
        transactions: [FeedItem]
    ) {
        presentRoundedUpViewControllerCallsCount += 1
    }
}
