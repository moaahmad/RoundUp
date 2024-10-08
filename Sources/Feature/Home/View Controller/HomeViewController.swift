//
//  HomeViewController.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 06/09/2024.
//

import Combine
import SnapKit
import UIKit

final class HomeViewController: BaseViewController {
    // MARK: - Properties

    private let viewModel: HomeViewModeling
    private var cancellables = Set<AnyCancellable>()

    // MARK: - UI Components

    private lazy var tableView = UITableView(frame: .zero, style: .plain)
    private lazy var dataSource = makeDataSource()
    private lazy var accountInfoView = AccountInfoView()
    private lazy var transactionsHeaderView = TransactionsHeaderView()
    private lazy var emptyStateView = EmptyView(
        message: viewModel.emptyState.message,
        description: viewModel.emptyState.description
    )

    // MARK: - Initializers

    init(viewModel: HomeViewModeling) {
        self.viewModel = viewModel
        super.init()
    }

    // MARK: - View Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configureUserInteractions()
        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFeed()
    }
}

// MARK: - UITableView Delegate

extension HomeViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        !viewModel.isFeedEmpty ? transactionsHeaderView : nil
    }
}

// MARK: - UITableView DataSource

private extension HomeViewController {
    enum Section {
        case main
    }

    func makeDataSource() -> UITableViewDiffableDataSource<Section, FeedItem> {
        UITableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: { tableView, indexPath, feedItem in
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: TransactionRowCell.reuseID,
                    for: indexPath
                ) as? TransactionRowCell else {
                    assertionFailure("Unable to dequeue TransactionRowCell")
                    return UITableViewCell()
                }

                cell.update(with: feedItem)
                return cell
            }
        )
    }

    func applySnapshot(for feedItems: [FeedItem], animate: Bool = false) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, FeedItem>()
        snapshot.appendSections([Section.main])
        snapshot.appendItems(feedItems, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: animate)
    }
}

// MARK: - Setup Views

private extension HomeViewController {
    func setupView() {
        title = viewModel.title
        setupTableView()
        setupAccountInfoView()
        setupEmptyStateView()
    }

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.register(
            TransactionRowCell.self,
            forCellReuseIdentifier: TransactionRowCell.reuseID
        )
        tableView.removeExcessCells()
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .systemBackground
        tableView.refreshControl = UIRefreshControl()

        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
    }

    func setupAccountInfoView() {
        tableView.tableHeaderView = accountInfoView

        accountInfoView.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.top).offset(amount: .md)
            make.horizontalEdges.equalToSuperview().inset(amount: .md)
            make.height.equalTo(180)
            make.centerX.equalToSuperview()
        }
    }

    func setupEmptyStateView() {
        emptyStateView.isHidden = true

        view.addSubview(emptyStateView)

        emptyStateView.snp.makeConstraints { make in
            make.edges.equalTo(tableView).inset(amount: .md)
        }
    }
}

// MARK: - User Interactions

private extension HomeViewController {
    @objc func onRoundUpTapped() {
        viewModel.didTapRoundUp()
    }

    @objc func onSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        viewModel.didChangeSegmentedControl(
            index: sender.selectedSegmentIndex
        )
    }

    @objc func refreshControlDidStart(
        sender: UIRefreshControl?,
        event: UIEvent?
    ) {
        loadFeed()
    }

    func configureUserInteractions() {
        tableView.refreshControl?.addTarget(
            self,
            action: #selector(refreshControlDidStart),
            for: .valueChanged
        )

        transactionsHeaderView.roundUpButton.addTarget(
            self,
            action: #selector(onRoundUpTapped),
            for: .touchUpInside
        )

        transactionsHeaderView.segmentedControl.addTarget(
            self,
            action: #selector(onSegmentedControlValueChanged),
            for: .valueChanged
        )
    }
}

// MARK: - Bindings

private extension HomeViewController {
    // swiftlint:disable:next function_body_length
    func bindViewModel() {
        viewModel.isLoading
            .removeDuplicates()
            .sink { [weak self] isLoading in
                guard let self else { return }
                if isLoading {
                    emptyStateView.isHidden = true
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

        viewModel.userInfo
            .filter { !$0.accountNumber.isEmpty }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] userInfo in
                self?.accountInfoView.configure(
                    name: userInfo.name,
                    accountNumber: userInfo.accountNumber,
                    sortCode: userInfo.sortCode,
                    balance: userInfo.balance.formattedString
                )
            }
            .store(in: &cancellables)

        viewModel.feedItems
            .combineLatest(viewModel.isLoading)
            .drop(while: { _, isLoading in
                isLoading == true
            })
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items, isLoading in
                guard let self else { return }
                updateView(for: items, isLoading: isLoading)
            }
            .store(in: &cancellables)

        viewModel.filteredFeedItems
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                self?.applySnapshot(for: items)
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

// MARK: - Private Helpers

private extension HomeViewController {
    func loadFeed() {
        resetSegmentedControl()
        viewModel.fetchData { [weak self] in
            if let refreshControl = self?.tableView.refreshControl,
               refreshControl.isRefreshing {
                self?.tableView.endRefreshing()
            }
        }
    }

    func resetSegmentedControl() {
        transactionsHeaderView.segmentedControl.selectedSegmentIndex = 0
    }

    func updateView(for items: [FeedItem], isLoading: Bool) {
        if !isLoading {
            emptyStateView.isHidden = !items.isEmpty
        }
    }
}
