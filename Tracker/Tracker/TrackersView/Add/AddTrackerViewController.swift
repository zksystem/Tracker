//
//  AddTrackerViewController.swift
//  Tracker
//
//  Created by Konstantin Zuykov on 17.06.2023.
//

import UIKit

protocol AddTrackerViewControllerDelegate: AnyObject {
    func didSelectTracker(with: AddTrackerViewController.TrackerType)
}

final class AddTrackerViewController: UIViewController {
    
    // MARK: - Layout elements
    
    private lazy var addHabitButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 335, height: 60))
        button.setTitle(NSLocalizedString("habit", tableName: "Localizable", comment: "habit"), for: .normal)
        button.backgroundColor = .appBlack
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.appWhite, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapAddHabitButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var addIrregularEventButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 335, height: 60))
        button.setTitle(NSLocalizedString("irregular", tableName: "Localizable", comment: "irregular"), for: .normal)
        button.backgroundColor = .appBlack
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.appWhite, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapAddIrregularEventButton), for: .touchUpInside)
        return button
    }()
    
    private let buttonsStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 16
        return stack
    }()
    
    // MARK: - Properties
    
    weak var delegate: AddTrackerViewControllerDelegate?
    
    private var labelText = ""
    private var category: String?
    private var schedule: [Weekday]?
    private var emoji: String?
    private var color: UIColor?
    
    private var isConfirmButtonEnabled: Bool {
        labelText.count > 0 && !isValidationMessageVisible
    }
    
    private var isValidationMessageVisible = false
    private var parameters = [NSLocalizedString("category", tableName: "Localizable", comment: "category"),
                        NSLocalizedString("schedule", tableName: "Localizable", comment: "schedule")]
    private let emojis = [ "🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶",
                          "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝", "😪"
    ]
    private let colors = UIColor.selection
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupContent()
        setupConstraints()
    }
    
    // MARK: - Actions
    
    @objc
    private func didTapAddHabitButton() {
        title = NSLocalizedString("new_habit", tableName: "Localizable", comment: "new_habit")
        delegate?.didSelectTracker(with: .habit)
    }
    
    @objc
    private func didTapAddIrregularEventButton() {
        delegate?.didSelectTracker(with: .irregularEvent)
    }
}
// MARK: - Layout methods

extension AddTrackerViewController {
    
    func setupContent() {
        title = NSLocalizedString("create_tracker", tableName: "Localizable", comment: "create_tracker")
        view.backgroundColor = .appWhite
        
        view.addSubview(buttonsStack)
        
        buttonsStack.addArrangedSubview(addHabitButton)
        buttonsStack.addArrangedSubview(addIrregularEventButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            buttonsStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            buttonsStack.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            buttonsStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),

            addHabitButton.heightAnchor.constraint(equalToConstant: 60),

            addIrregularEventButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
}

extension AddTrackerViewController {
    enum TrackerType {
        case habit, irregularEvent
    }
}
