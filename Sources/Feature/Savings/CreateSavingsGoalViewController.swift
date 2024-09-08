//
//  CreateSavingsGoalViewController.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 07/09/2024.
//

import Combine
import UIKit
import SnapKit

protocol CreateSavingsGoalViewModeling {
    func didTapCreateSavingsGoal()
}

final class CreateSavingsGoalViewModel: CreateSavingsGoalViewModeling {
    // MARK: - Properties

    private let service: SavingsServicing
    let accountUid = "b74e212a-738b-426c-bbec-d17b6e406716" // TODO: REMOVE THIS!

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initializer

    init(
        service: SavingsServicing
    ) {
        self.service = service
    }

    func didTapCreateSavingsGoal() {
        service.createSavingsGoal(
            accountUid: accountUid,
            savingsGoalRequest: SavingsGoalRequest(
                name: "Trip to London",
                currency: "GBP"
            )
        )
        .catch { error -> AnyPublisher<CreateOrUpdateSavingsGoalResponse, Never> in
            print(error.localizedDescription)
            return Empty().eraseToAnyPublisher()
        }
        .sink {
            print("Saving Goal ID: \($0.savingsGoalUid), success: \($0.success)")
        }
        .store(in: &cancellables)
    }
}

final class CreateSavingsGoalViewController: BaseViewController {
    // MARK: - Properties

    private let viewModel: CreateSavingsGoalViewModeling
    private let currencies = Currency.allCases.map { $0.rawValue }

    // MARK: - UI Elements

    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter goal name"
        textField.borderStyle = .roundedRect
        return textField
    }()

    private let currencyTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Select currency"
        textField.borderStyle = .roundedRect
        return textField
    }()

    private let targetAmountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter target amount"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .decimalPad
        return textField
    }()

    private lazy var createGoalButton = STActionButton(title: "Create Goal")
    private lazy var currencyPicker = UIPickerView()

    // MARK: - Initializers

    init(viewModel: CreateSavingsGoalViewModeling) {
        self.viewModel = viewModel
        super.init()
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupCurrencyPicker()

        createGoalButton.addTarget(
            self,
            action: #selector(createGoalButtonTapped),
            for: .touchUpInside
        )
    }

    // MARK: - Setup Layout

    private func setupLayout() {
        view.addSubview(nameTextField)
        view.addSubview(currencyTextField)
        view.addSubview(targetAmountTextField)
        view.addSubview(createGoalButton)

        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }

        currencyTextField.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }

        targetAmountTextField.snp.makeConstraints { make in
            make.top.equalTo(currencyTextField.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }

        createGoalButton.snp.makeConstraints { make in
            make.top.equalTo(targetAmountTextField.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
    }

    // MARK: - Setup Currency Picker

    private func setupCurrencyPicker() {
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        currencyTextField.inputView = currencyPicker
    }

    // MARK: - Actions

    @objc private func createGoalButtonTapped() {
        guard let name = nameTextField.text, !name.isEmpty,
              let currency = currencyTextField.text, !currency.isEmpty,
              let targetText = targetAmountTextField.text, !targetText.isEmpty,
              let targetAmount = Int64(targetText) 
        else {
            showAlert(message: "Please fill in all fields")
            return
        }

        // Perform the create savings goal action here
        print("Creating savings goal with name: \(name), currency: \(currency), target: \(targetAmount)")
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
}
