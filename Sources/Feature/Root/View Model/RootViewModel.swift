//
//  RootViewModel.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 10/09/2024.
//

import Combine
import Foundation

final class RootViewModel: RootViewModeling {
    // MARK: - Properties

    private let service: RootServicing
    private let appState: AppStateProviding

    var rootDestination = CurrentValueSubject<RootDestination, Never>(.loading)
    var errorPublisher = PassthroughSubject<Error, Never>()
    weak var coordinator: Coordinator?
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initializer

    init(
        service: RootServicing,
        coordinator: Coordinator?,
        appState: AppStateProviding = AppState.shared
    ) {
        self.service = service
        self.coordinator = coordinator
        self.appState = appState
    }

    // MARK: - RootViewModeling Functions

    func fetchData() {
        service.fetchAccounts()
            .map(\.accounts)
            .compactMap { $0.first(where: { $0.accountType == .primary }) }
            .receive(on: DispatchQueue.main)
            .catch { [weak self] error -> AnyPublisher<Account, Never> in
                self?.errorPublisher.send(error)
                return Empty().eraseToAnyPublisher()
            }
            .sink { [weak self] in
                self?.appState.updateAccount(with: $0)
                self?.rootDestination.send(.home)
            }
            .store(in: &cancellables)
    }

    func navigateTo(_ rootDestination: RootDestination) {
        switch rootDestination {
        case .loading:
            return
        case .home:
            guard let coordinator = coordinator as? RootCoordinator else {
                return
            }
            coordinator.navigateToAppTab()
        }
    }
}
