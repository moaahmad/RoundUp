//
//  SavingsGoalsService.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 06/09/2024.
//

import Combine
import Foundation

protocol SavingsGoalsServicing {
    func fetchAllSavingGoals(for accountUid: String) -> Future<SavingsGoalsResponse, Error>
    func createSavingsGoal(
        accountUid: String,
        savingsGoalRequest: SavingsGoalRequest
    ) -> Future<CreateOrUpdateSavingsGoalResponse, Error>
    func addMoneyToSavingsGoal(
        accountUid: String,
        savingsGoalUid: String,
        transferUid: String,
        topUpRequest: TopUpRequest
    ) -> Future<SavingsGoalTransferResponse, Error>
    func deleteSavingsGoal()
}

struct SavingsService: SavingsGoalsServicing {
    // MARK: - Properties

    private let client: HTTPClient
    private let urlRequestPool: SavingsURLRequestPooling
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    // MARK: - Initializer

    init(
        client: HTTPClient = URLSessionHTTPClient(),
        urlRequestPool: SavingsURLRequestPooling = URLRequestPool(),
        decoder: JSONDecoder = .init(),
        encoder: JSONEncoder = .init()
    ) {
        self.client = client
        self.urlRequestPool = urlRequestPool
        self.decoder = decoder
        self.encoder = encoder
    }

    // MARK: - SavingsServicing Functions

    func fetchAllSavingGoals(for accountUid: String) -> Future<SavingsGoalsResponse, Error> {
        client.fetchData(
            request: urlRequestPool.allSavingsGoalsRequest(accountUid: accountUid),
            responseType: SavingsGoalsResponse.self,
            decoder: decoder
        )
    }

    func createSavingsGoal(
        accountUid: String,
        savingsGoalRequest: SavingsGoalRequest
    ) -> Future<CreateOrUpdateSavingsGoalResponse, Error> {
        Future<CreateOrUpdateSavingsGoalResponse, Error> { promise in
            do {
                let encodedRequest = try encoder.encode(savingsGoalRequest)
                client.performRequest(
                    urlRequestPool.createSavingsGoal(
                        accountUid: accountUid,
                        savingsGoalRequestData: encodedRequest
                    )
                ) { result in
                    switch result {
                    case let .success((data, response)):
                        client.handleFetchSuccessResponse(
                            data: data,
                            response: response,
                            decoder: decoder,
                            promise: promise
                        )
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }
            } catch {
                promise(.failure(error))
            }
        }
    }

    func addMoneyToSavingsGoal(
        accountUid: String,
        savingsGoalUid: String,
        transferUid: String,
        topUpRequest: TopUpRequest
    ) -> Future<SavingsGoalTransferResponse, Error> {
        Future<SavingsGoalTransferResponse, Error> { promise in
            do {
                let encodedRequest = try encoder.encode(topUpRequest)
                client.performRequest(
                    urlRequestPool.topUpSavingsGoal(
                        accountUid: accountUid,
                        savingsGoalUid: savingsGoalUid,
                        transferUid: transferUid,
                        topUpRequestData: encodedRequest
                    )
                ) { result in
                    switch result {
                    case let .success((data, response)):
                        client.handleFetchSuccessResponse(
                            data: data,
                            response: response,
                            decoder: decoder,
                            promise: promise
                        )
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }
            } catch {
                promise(.failure(error))
            }
        }
    }

    func deleteSavingsGoal() {
        //
    }
}
