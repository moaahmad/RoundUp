//
//  RoundUpViewController.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 07/09/2024.
//

import Combine
import SnapKit
import UIKit

final class RoundUpViewController: BaseViewController {
    // MARK: - Properties

    private let viewModel: RoundUpViewModeling

    private var selectedIndexPath: IndexPath?
    private var cancellables = Set<AnyCancellable>()

    // MARK: - UI Elements

    private lazy var navigationBar: UINavigationBar = {
        UINavigationBar(
            frame: CGRect(
                x: .none, y: .none,
                width: view.frame.size.width,
                height: 50
            )
        )
    }()

    private lazy var headerView = RoundUpTotalView(total: viewModel.roundedUpTotal.formattedAmount!)
    private lazy var saveButton = STActionButton(title: "Save")
    private lazy var tableView = UITableView(frame: .zero, style: .plain)
    private lazy var dataSource = makeDataSource()

    // MARK: - Initializers

    init(viewModel: RoundUpViewModeling) {
        self.viewModel = viewModel
        super.init()
    }

    // MARK: - View Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
        viewModel.fetchData()
    }

    // MARK: - User Interactions

    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }

    @objc private func saveButtonTapped() {
        viewModel.saveRoundedUpTotal { [weak self] in
            self?.dismiss(animated: true)
        }
    }
}

// MARK: - UITableView Delegate

extension RoundUpViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.selectSavingsGoal(at: indexPath.row)
    }
}

// MARK: - UITableView DataSource

private extension RoundUpViewController {
    enum Section {
        case main
    }

    func makeDataSource() -> UITableViewDiffableDataSource<Section, SavingsGoal> {
        UITableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: { tableView, indexPath, savingsGoal in
                let cell = UITableViewCell()
                var content = cell.defaultContentConfiguration()
                content.text = savingsGoal.name
                content.secondaryText = "Saved: \(savingsGoal.totalSaved.formattedAmount!), Target: \(savingsGoal.target?.formattedAmount! ?? "0")"
                if let isSelected = savingsGoal.isSelected {
                    cell.accessoryType = isSelected ? .checkmark : .none
                }
                cell.backgroundColor = .systemBackground
                cell.contentConfiguration = content
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

private extension RoundUpViewController {
    func setupViews() {
        setupNavigationBar()
        setupTableView()
        setupSaveButton()
    }

    func setupNavigationBar() {
        let navigationItem = UINavigationItem(title: "Save Round Up")
        let closeButton = UIBarButtonItem(
            title: "Close",
            style: .plain,
            target: self,
            action: #selector(closeButtonTapped)
        )
        navigationItem.rightBarButtonItem = closeButton
        navigationBar.setItems([navigationItem], animated: false)
        view.addSubview(navigationBar)
    }

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.removeExcessCells()
        tableView.backgroundColor = .systemBackground

        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }

        setupHeaderView()
    }

    func setupHeaderView() {
        tableView.tableHeaderView = headerView

        headerView.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.top)
            make.leading.equalTo(tableView.snp.leading).padding(.base)
            make.trailing.equalTo(tableView.snp.trailing).padding(-.base)
            make.width.equalTo(tableView.snp.width).padding(-.xxl)
        }
    }

    func setupSaveButton() {
        saveButton.isEnabled = false
        saveButton.backgroundColor = .systemGray
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        view.addSubview(saveButton)

        saveButton.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).padding(.md)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.equalToSuperview().padding(.base)
            make.trailing.equalToSuperview().padding(-.base)
            make.height.equalTo(50)
        }
    }
}

// MARK: Bindings

private extension RoundUpViewController {
    func bindViewModel() {
//        viewModel.isLoading
//            .removeDuplicates()
//            .sink { [weak self] isLoading in
//                guard let self else { return }
//                if isLoading {
//
//                } else {
//
//                }
//            }
//            .store(in: &cancellables)

        viewModel.selectedSavingsGoal
            .compactMap(\.?.isSelected)
            .filter { $0 == true }
            .removeDuplicates()
            .sink { [weak self] _ in
                UIView.animate(withDuration: 0.3) { [weak self] in
                    self?.saveButton.isEnabled = true
                    self?.saveButton.backgroundColor = .accent
                }
            }
            .store(in: &cancellables)

        viewModel.isSavingRoundUp
            .removeDuplicates()
            .sink { [weak self] in
                self?.saveButton.showLoading($0)
            }
            .store(in: &cancellables)

        viewModel.savingsGoals
            .receive(on: DispatchQueue.main)
            .filter { !$0.isEmpty }
            .sink { [weak self] in
                print("Savings Goals:", $0)
                self?.applySnapshot(with: $0, animate: false)
            }
            .store(in: &cancellables)
    }
}
