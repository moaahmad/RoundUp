//
//  SavingsGoalsViewController.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 06/09/2024.
//

import Combine
import SnapKit
import UIKit

final class SavingsGoalsViewController: BaseViewController {
    // MARK: - Properties

    private let viewModel: SavingsGoalsViewModeling

    private var cancellables = Set<AnyCancellable>()
    private lazy var tableView = UITableView(frame: .zero, style: .grouped)
    private lazy var dataSource = makeDataSource()
    private lazy var emptyStateView = EmptyView(
        message: "No Savings Goals",
        description: "Tap + to create a new savings goal."
    )

    // MARK: - Initializers

    init(viewModel: SavingsGoalsViewModeling) {
        self.viewModel = viewModel
        super.init()
    }

    // MARK: - View Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchData()
    }

    // MARK: - User Interactions

    @objc private func onPlusButtonTapped() {
        viewModel.didTapPlusButton()
    }

    @objc private func refreshControlDidStart(sender: UIRefreshControl?, event: UIEvent?) {
        viewModel.fetchData()
    }
}

// MARK: - TableView DataSource

private extension SavingsGoalsViewController {
    enum Section {
        case main
    }

    func makeDataSource() -> UITableViewDiffableDataSource<Section, SavingsGoal> {
        UITableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: { tableView, indexPath, savingsGoal in
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: SavingsGoalCell.reuseID,
                    for: indexPath
                ) as? SavingsGoalCell else {
                    assertionFailure("Unable to dequeue SavingsGoalCell")
                    return UITableViewCell()
                }

                cell.update(with: savingsGoal)
                return cell
            }
        )
    }

    func applySnapshot(with savingsGoals: [SavingsGoal], animate: Bool = false) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, SavingsGoal>()
        snapshot.appendSections([Section.main])
        snapshot.appendItems(savingsGoals, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: animate)
    }
}

// MARK: - Setup Views

private extension SavingsGoalsViewController {
    func setupView() {
        setupNavigationBar()
        setupTableView()
        setupEmptyStateView()
    }

    func setupNavigationBar() {
        title = "goals_tab_title".localized()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus.circle"),
            style: .plain,
            target: self,
            action: #selector(onPlusButtonTapped)
        )
    }

    func setupTableView() {
        tableView.dataSource = dataSource
        tableView.register(
            SavingsGoalCell.self,
            forCellReuseIdentifier: SavingsGoalCell.reuseID
        )
        tableView.removeExcessCells()
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .systemBackground

        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
    }

    func setupEmptyStateView() {
        emptyStateView.isHidden = true
        view.addSubview(emptyStateView)

        emptyStateView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(amount: .md)
        }
    }
}

// MARK: Bindings

private extension SavingsGoalsViewController {
    func bindViewModel() {
        viewModel.isLoading
            .removeDuplicates()
            .sink { [weak self] isLoading in
                guard let self else { return }
                if isLoading {
                    tableView.isHidden = true
                    showLoadingView()
                } else {
                    UIView.animate(withDuration: 0.3) { [weak self] in
                        self?.dismissLoadingView()
                        self?.tableView.isHidden = false
                    }
                }
            }
            .store(in: &cancellables)
        
        viewModel.savingsGoals
            .filter { [weak self] _ in
                guard let isLoading = self?.viewModel.isLoading.value else {
                    return false
                }
                return !isLoading
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] goals in
                guard let self else { return }
                applySnapshot(with: goals)
                updateView(for: goals)
            }
            .store(in: &cancellables)

        viewModel.errorPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.showErrorAlert(error: error)
            }
            .store(in: &cancellables)
    }
}

// MARK: - Private Helpers

private extension SavingsGoalsViewController {
    func updateView(for goals: [SavingsGoal]) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else { return }
            tableView.isHidden = goals.isEmpty
            emptyStateView.isHidden = !goals.isEmpty
        }
    }
}
