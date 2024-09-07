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

    @objc
    func onPlusButtonTapped() {
        viewModel.didTapPlusButton()
    }
}

// MARK: - Setup Views

private extension SavingsViewController {
    func setupView() {
        view.backgroundColor = .systemBackground
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
        tableView.removeExcessCells()
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
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

// MARK: - TableView DataSource

private extension SavingsViewController {
    func makeDataSource() -> UITableViewDiffableDataSource<Section, SavingsGoal> {
        UITableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: { tableView, indexPath, savingsGoal in
                let cell = UITableViewCell()
                var content = cell.defaultContentConfiguration()
                content.text = savingsGoal.name
                content.secondaryText = "Saved: \(savingsGoal.totalSaved.formattedAmount!), Target: \(savingsGoal.target?.formattedAmount! ?? "0")"
                cell.contentConfiguration = content
                return cell
            }
        )
    }

    func update(with savingsGoals: [SavingsGoal], animate: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, SavingsGoal>()
        snapshot.appendSections([Section.main])
        snapshot.appendItems(savingsGoals, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: animate)
    }
}
