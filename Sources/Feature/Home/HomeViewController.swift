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

    private lazy var tableView = UITableView(frame: .zero, style: .plain)
    private lazy var dataSource = makeDataSource()
    private lazy var accountInfoView = AccountInfoView()
    private lazy var transactionsHeaderView = TransactionsHeaderView()

    // MARK: - Initializers

    init(viewModel: HomeViewModeling) {
        self.viewModel = viewModel
        super.init()
    }

    // MARK: - View Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        bindViewModel()
        configureTableView()

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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchData()
    }

    // MARK: - User Interactions

    @objc private func onRoundUpTapped() {
        viewModel.didTapRoundUp()
    }

    @objc func onSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        viewModel.didChangeSegmentedControl(index: sender.selectedSegmentIndex)
    }
}

// MARK: - UITableViewDelegate Conformance

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        transactionsHeaderView
    }
}

// MARK: - Setup Views

private extension HomeViewController {
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = dataSource
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

        setupAccountInfoView()
    }

    func setupAccountInfoView() {
        tableView.tableHeaderView = accountInfoView

        accountInfoView.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.top).padding(.md)
            make.leading.equalTo(tableView.snp.leading).padding(.base)
            make.trailing.equalTo(tableView.snp.trailing).padding(-.base)
            make.height.equalTo(UIScreen.main.bounds.height * 0.2)
            make.width.equalTo(tableView.snp.width).padding(-.xxl)
        }
    }
}

// MARK: - TableView DataSource

private extension HomeViewController {
    enum Section {
        case main
    }

    func makeDataSource() -> UITableViewDiffableDataSource<Section, FeedItem> {
        UITableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: { tableView, indexPath, feedItem in
                let cell = UITableViewCell()
                var content = cell.defaultContentConfiguration()
                content.text = feedItem.reference
                content.secondaryText = "\(feedItem.amount!.formattedAmount!), Direction: \(feedItem.direction!.rawValue)"
                cell.backgroundColor = .systemBackground
                cell.contentConfiguration = content
                return cell
            }
        )
    }

    func update(with feedItems: [FeedItem], animate: Bool = false) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, FeedItem>()
        snapshot.appendSections([Section.main])
        snapshot.appendItems(feedItems, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: animate)
    }
}

// MARK: - Bindings

private extension HomeViewController {
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

        Publishers.CombineLatest(
            viewModel.userInfo,
            viewModel.filteredFeedItems
        )
        .filter { !$0.0.accountNumber.isEmpty && !$0.1.isEmpty }
        .receive(on: DispatchQueue.main)
        .sink { [weak self] userInfo, feedItems in
            print("userInfo:", userInfo)
            print("feedItems:", feedItems.count)

            self?.accountInfoView.configure(
                name: userInfo.name,
                accountNumber: userInfo.accountNumber,
                sortCode: userInfo.sortCode,
                balance: userInfo.balance
            )
            self?.update(with: feedItems)
        }
        .store(in: &cancellables)
    }
}
