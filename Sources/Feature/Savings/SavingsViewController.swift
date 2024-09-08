//
//  SavingsViewController.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 06/09/2024.
//

import Combine
import SnapKit
import UIKit

final class SavingsViewController: BaseViewController {
    enum Section {
        case main
    }

    // MARK: - Properties

    private let viewModel: SavingsViewModeling

    private var cancellables = Set<AnyCancellable>()
    private lazy var tableView = UITableView(frame: .zero, style: .grouped)
    private lazy var dataSource = makeDataSource()

    // MARK: - Initializers

    init(viewModel: SavingsViewModeling) {
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
}

// MARK: - TableView DataSource

private extension SavingsViewController {
    func makeDataSource() -> UITableViewDiffableDataSource<Section, SavingsGoal> {
        UITableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: { tableView, indexPath, savingsGoal in
                // Dequeue the custom cell
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: SavingsGoalCell.reuseID,
                    for: indexPath
                ) as? SavingsGoalCell else {
                    fatalError("Unable to dequeue SavingsGoalCell")
                }

                // Configure the custom cell with data
                cell.update(with: savingsGoal)
                return cell
            }
        )
    }

    func update(with savingsGoals: [SavingsGoal], animate: Bool = false) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, SavingsGoal>()
        snapshot.appendSections([Section.main])
        snapshot.appendItems(savingsGoals, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: animate)
    }
}

// MARK: - Setup Views

private extension SavingsViewController {
    func setupView() {
        setupNavigationBar()
        setupTableView()
    }

    func setupNavigationBar() {
        title = "Savings"
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
        tableView.register(SavingsGoalCell.self, forCellReuseIdentifier: SavingsGoalCell.reuseID)
        tableView.removeExcessCells()
        tableView.allowsSelection = false
        tableView.backgroundColor = .systemBackground

        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
    }
}

// MARK: Bindings

private extension SavingsViewController {
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
            .receive(on: DispatchQueue.main)
            .filter { !$0.isEmpty }
            .sink { [weak self] in
                print("Savings Goals:", $0)
                self?.update(with: $0)
            }
            .store(in: &cancellables)
    }
}
