//
//  CreateSavingsGoalViewController.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 07/09/2024.
//

import UIKit
import SnapKit

final class CreateSavingsGoalViewController: BaseViewController {
    // MARK: - Properties

    private let viewModel: CreateSavingsGoalViewModeling
    private let currencies = Currency.allCases.map { $0.rawValue }

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
        let textField = STTextField(placeholder: "Enter goal name")
        textField.snp.makeConstraints { make in make.height.equalTo(CGFloat.textFieldHeight) }
        textField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        return textField
    }()

    private lazy var currencyTextField: STTextField = {
        let textField = STTextField(placeholder: "Select currency")
        textField.snp.makeConstraints { make in make.height.equalTo(CGFloat.textFieldHeight) }
        textField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        return textField
    }()

    private lazy var targetAmountTextField: STTextField = {
        let textField = STTextField(
            placeholder: "Enter target amount",
            keyboardType: .decimalPad
        )
        textField.snp.makeConstraints { make in make.height.equalTo(CGFloat.textFieldHeight) }
        textField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        return textField
    }()

    private lazy var createGoalButton: STActionButton = {
        let button = STActionButton(title: "Create Goal")
        button.isEnabled = false
        button.backgroundColor = .systemGray
        button.addTarget(self, action: #selector(createGoalButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var currencyPicker = UIPickerView()

    private lazy var navigationBar: UINavigationBar = {
        UINavigationBar(
            frame: CGRect(
                x: .none, y: .none,
                width: view.frame.size.width,
                height: .navigationBarHeight
            )
        )
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
        setupCurrencyPicker()
    }

    // MARK: - User Interactions

    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }

    // MARK: - Setup Currency Picker

    private func setupCurrencyPicker() {
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        currencyTextField.inputView = currencyPicker
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
        )
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

// MARK: - UIPickerView DataSource & Delegate

extension CreateSavingsGoalViewController: UIPickerViewDelegate & UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(
        _ pickerView: UIPickerView,
        numberOfRowsInComponent component: Int
    ) -> Int {
        currencies.count
    }

    func pickerView(
        _ pickerView: UIPickerView,
        titleForRow row: Int,
        forComponent component: Int
    ) -> String? {
        currencies[row]
    }

    func pickerView(
        _ pickerView: UIPickerView,
        didSelectRow row: Int,
        inComponent component: Int
    ) {
        currencyTextField.text = currencies[row]
        currencyTextField.resignFirstResponder()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - Setup Views

private extension CreateSavingsGoalViewController {
    func setupViews() {
        setupContentView()
        setupScrollView()
    }

    func setupContentView() {
        let navigationItem = UINavigationItem(title: "Create Savings Goal")
        let closeButton = UIBarButtonItem(
            title: "Close",
            style: .plain,
            target: self,
            action: #selector(closeButtonTapped)
        )
        navigationItem.rightBarButtonItem = closeButton
        navigationBar.setItems([navigationItem], animated: false)

        view.addSubview(navigationBar)
        view.addSubview(scrollView)
        view.addSubview(createGoalButton)

        navigationBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(createGoalButton.snp.top).inset(amount: .base)
        }

        createGoalButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(amount: .base)
            make.leading.trailing.equalToSuperview().inset(amount: .base)
            make.height.equalTo(CGFloat.buttonHeight)
        }
    }

    func setupScrollView() {
        scrollView.addSubview(scrollStackViewContainer)

        scrollStackViewContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(amount: .base)
            make.width.equalTo(scrollView.snp.width).inset(amount: .base)
        }
    }
}
