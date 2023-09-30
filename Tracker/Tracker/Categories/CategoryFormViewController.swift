//
//  CategoryFormViewController.swift
//  Tracker
//
//  Created by Konstantin Zuykov on 20.09.2023.
//

import UIKit

protocol CategoryFormViewControllerDelegate: AnyObject {
    func didConfirm(_ data: TrackerCategory.Data)
}

final class CategoryFormViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: CategoryFormViewControllerDelegate?
    private var data: TrackerCategory.Data
    private var isConfirmButtonEnabled: Bool = false {
        willSet {
            if newValue {
                button.backgroundColor = .appBlack
                button.isEnabled = true
            } else {
                button.backgroundColor = .appGray
                button.isEnabled = false
            }
        }
    }
    
    // MARK: - Layout elements
    
    private lazy var textField: UITextField = {
        let textField = TextField(placeholder: NSLocalizedString("input_category_name", tableName: "Localizable", comment: "input_category_name"))
        textField.addTarget(self, action: #selector(didChangedTextField), for: .editingChanged)
        return textField
    }()
    private lazy var button: UIButton = {
        let button = RoundedButton(title: NSLocalizedString("ready", tableName: "Localizable", comment: "ready"))
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        button.isEnabled = false
        button.backgroundColor = .appGray
        return button
    }()
    
    // MARK: - Lifecycle
    
    init(data: TrackerCategory.Data = TrackerCategory.Data()) {
        self.data = data
        
        super.init(nibName: nil, bundle: nil)
        
        textField.text = data.label
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupContent()
        setupConstraints()
    }
    
    // MARK: - Actions
    
    @objc
    private func didChangedTextField(_ sender: UITextField) {
        if let text = sender.text, !text.isEmpty {
            data.label = text
            isConfirmButtonEnabled = true
        } else {
            isConfirmButtonEnabled = false
        }
    }
    
    @objc
    private func didTapButton() {
        delegate?.didConfirm(data)
    }
}

// MARK: - Layout methods

private extension CategoryFormViewController {
    func setupContent() {
        title = NSLocalizedString("new_category", tableName: "Localizable", comment: "new_category")
        view.backgroundColor = .appWhite
        view.addSubview(textField)
        view.addSubview(button)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([

            textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: ListCellPlaceHolder.height),

            button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            button.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
