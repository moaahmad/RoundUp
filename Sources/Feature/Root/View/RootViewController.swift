//
//  RootViewController.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 10/09/2024.
//

import Combine
import UIKit

final class RootViewController: BaseViewController {
    // MARK: - Properties

    private let viewModel: RootViewModeling
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initializers

    init(viewModel: RootViewModeling) {
        self.viewModel = viewModel
        super.init()
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        viewModel.fetchData()
    }
}

// MARK: - Bindings

private extension RootViewController {
    func bindViewModel() {
        viewModel.rootDestination
            .removeDuplicates()
            .sink { [weak self] rootDestination in
                guard let self else { return }
                switch rootDestination {
                case .loading:
                    break
                case .home:
                    viewModel.navigateTo(.home)
                }
            }
            .store(in: &cancellables)

        viewModel.errorPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.showErrorAlert(message: error.localizedDescription)
            }
            .store(in: &cancellables)
    }
}
