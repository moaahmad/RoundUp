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

    // MARK: - UI Components

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
        let textField = STTextField(placeholder: viewModel.nameTextPlaceholder)
        textField.snp.makeConstraints { make in make.height.equalTo(CGFloat.textFieldHeight) }
        textField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        return textField
    }()

    private lazy var currencyTextField: STTextField = {
        let textField = STTextField(placeholder: viewModel.selectCurrencyPlaceholder)
        textField.text = Currency.gbp.rawValue
        textField.snp.makeConstraints { make in make.height.equalTo(CGFloat.textFieldHeight) }
        textField.isUserInteractionEnabled = false
        return textField
    }()

    private lazy var targetAmountTextField: STTextField = {
        let textField = STTextField(
            placeholder: viewModel.targetAmountPlaceholder,
            keyboardType: .decimalPad
        )
        textField.snp.makeConstraints { make in make.height.equalTo(CGFloat.textFieldHeight) }
        textField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        return textField
    }()

    private lazy var createGoalButton: STActionButton = {
        let button = STActionButton(title: viewModel.createGoalTitle)
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
        targetAmountTextField.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameTextField.becomeFirstResponder()
    }
}

extension CreateSavingsGoalViewController: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        viewModel.shouldChangeCharacters(
            textField.text,
            shouldChangeCharactersIn: range,
            replacementString: string
        )
    }
}

// MARK: - Setup Views

private extension CreateSavingsGoalViewController {
    func setupViews() {
        setupContentView()
        setupScrollView()
    }

    func setupContentView() {
        title = viewModel.title
        navigationItem.rightBarButtonItem = .init(
            title: viewModel.closeTitle,
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

// MARK: - User Interactions

private extension CreateSavingsGoalViewController {
    @objc func closeButtonTapped() {
        dismiss(animated: true)
    }

    @objc func createGoalButtonTapped() {
        guard let name = nameTextField.text, !name.isEmpty,
              let currency = currencyTextField.text, !currency.isEmpty,
              let target = targetAmountTextField.text, !target.isEmpty
        else {
            showErrorAlert(message: viewModel.errorMessage)
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

    @objc func textFieldEditingChanged(_ sender: UITextField) {
        let isNameValid = !(nameTextField.text?.isEmpty ?? true)
        let isCurrencyValid = !(currencyTextField.text?.isEmpty ?? true)
        let isTargetValid = !(targetAmountTextField.text?.isEmpty ?? true)

        createGoalButton.isEnabled = isNameValid && isCurrencyValid && isTargetValid
        createGoalButton.backgroundColor = createGoalButton.isEnabled ? .accent : .systemGray
    }
}

// MARK: - Bindings

private extension CreateSavingsGoalViewController {
    func bindViewModel() {
        viewModel.errorPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.showErrorAlert(message: error.localizedDescription)
            }
            .store(in: &cancellables)
    }
}
