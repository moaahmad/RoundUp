//
//  CreateSavingsGoalViewController.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 07/09/2024.
//

import Combine
import UIKit
import SnapKit

final class CreateSavingsGoalViewController: BaseViewController {
    // MARK: - Properties

    private let viewModel: CreateSavingsGoalViewModeling
    private var cancellables = Set<AnyCancellable>()

    // MARK: - UI Elements

    private lazy var scrollView = UIScrollView()

    private lazy var scrollStackViewContainer: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [nameTextField, currencyTextField, targetAmountTextField]
        )
        stackView.axis = .vertical
        stackView.spacing = .base
        return stackView
    }()

    private lazy var nameTextField: STTextField = {
        let textField = STTextField(placeholder: "enter_goal_name_placeholder".localized())
        textField.snp.makeConstraints { make in make.height.equalTo(CGFloat.textFieldHeight) }
        textField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        return textField
    }()

    private lazy var currencyTextField: STTextField = {
        let textField = STTextField(placeholder: "select_currency_placeholder".localized())
        textField.text = Currency.gbp.rawValue
        textField.snp.makeConstraints { make in make.height.equalTo(CGFloat.textFieldHeight) }
        textField.isUserInteractionEnabled = false
        return textField
    }()

    private lazy var targetAmountTextField: STTextField = {
        let textField = STTextField(
            placeholder: "enter_target_amount_placeholder".localized(),
            keyboardType: .decimalPad
        )
        textField.snp.makeConstraints { make in make.height.equalTo(CGFloat.textFieldHeight) }
        textField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        return textField
    }()

    private lazy var createGoalButton: STActionButton = {
        let button = STActionButton(title: "create_goal_button_title".localized())
        button.isEnabled = false
        button.backgroundColor = .systemGray
        button.addTarget(self, action: #selector(createGoalButtonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Initializers

    init(viewModel: CreateSavingsGoalViewModeling) {
        self.viewModel = viewModel
        super.init()
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameTextField.becomeFirstResponder()
    }

    // MARK: - User Interactions

    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }

    // MARK: - User Interactions

    @objc private func createGoalButtonTapped() {
        guard let name = nameTextField.text, !name.isEmpty,
              let currency = currencyTextField.text, !currency.isEmpty,
              let target = targetAmountTextField.text, !target.isEmpty
        else {
            showAlert(message: "Please fill in all fields")
            return
        }

        viewModel.didTapCreateSavingsGoal(
            name: name,
            currency: currency,
            target: target
        ) { [weak self] in
            self?.dismiss(animated: true)
        }
    }

    @objc private func textFieldEditingChanged(_ sender: UITextField) {
        let isNameValid = !(nameTextField.text?.isEmpty ?? true)
        let isCurrencyValid = !(currencyTextField.text?.isEmpty ?? true)
        let isTargetValid = !(targetAmountTextField.text?.isEmpty ?? true)

        createGoalButton.isEnabled = isNameValid && isCurrencyValid && isTargetValid
        createGoalButton.backgroundColor = createGoalButton.isEnabled ? .accent : .systemGray
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - Setup Views

private extension CreateSavingsGoalViewController {
    func setupViews() {
        setupContentView()
        setupScrollView()
    }

    func setupContentView() {
        title = "create_savings_goal_title".localized()
        navigationItem.rightBarButtonItem = .init(
            title: "close".localized(),
            style: .plain,
            target: self,
            action: #selector(closeButtonTapped)
        )

        view.addSubview(scrollView)
        view.addSubview(createGoalButton)

        scrollView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(createGoalButton.snp.top).inset(amount: .base)
        }

        createGoalButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(amount: .base)
            make.leading.trailing.equalToSuperview().inset(amount: .base)
            make.height.equalTo(CGFloat.buttonHeight)
        }
    }

    func setupScrollView() {
        scrollView.alwaysBounceVertical = true
        scrollView.addSubview(scrollStackViewContainer)

        scrollStackViewContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(amount: .base)
            make.width.equalTo(scrollView.snp.width).inset(amount: .base)
        }
    }
}

// MARK: - Bindings

private extension CreateSavingsGoalViewController {
    func bindViewModel() {
        viewModel.errorPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.showErrorAlert(error: error)
            }
            .store(in: &cancellables)
    }
}
