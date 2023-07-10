//
//  TrackerFormViewController.swift
//  Tracker
//
//  Created by Konstantin Zuykov on 17.06.2023.
//

import UIKit

protocol TrackersFormViewControllerDelegate: AnyObject {
    func didTapCancelButton()
    func didTapConfirmButton(categoryLabel: String, trackerToAdd: Tracker)
}

final class TrackersFormViewController: UIViewController {
    
    // MARK: - Layout elements
    
    private lazy var textField: UITextField = {
        let textField = TextField(placeholder: "Введите название трекера")
        textField.addTarget(self, action: #selector(didChangedLabelTextField), for: .editingChanged)
        return textField
    }()
    
    private lazy var validationMessage: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .appRed
        label.text = "Ограничение 38 символов"
        return label
    }()
    
    private lazy var parametersTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorStyle = .none
        table.isScrollEnabled = true
        table.register(TableViewCellPlaceHolder.self, forCellReuseIdentifier: TableViewCellPlaceHolder.identifier)
        return table
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = RoundedButton.redButton(title: "Отменить")
        button.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var confirmButton: UIButton = {
        let button = RoundedButton(title: "Создать")
        button.addTarget(self, action: #selector(didTapConfirmButton), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    private lazy var buttonsStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 8
        stack.distribution = .fillEqually
        return stack
    }()
    
    // MARK: - Properties
    
    weak var delegate: TrackersFormViewControllerDelegate?
    private let type: AddTrackerViewController.TrackerType
    
    private var data: Tracker.Data {
        didSet {
            checkFromValidation()
        }
    }
    
    private var category: String? = TrackerCategory.sampleData[0].label {
        didSet {
            checkFromValidation()
        }
    }

    private var scheduleString: String? {
        guard let schedule = data.schedule else { return nil }
        if schedule.count == Weekday.allCases.count { return "Каждый день" }
        let shortForms: [String] = schedule.map { $0.shortForm }
        return shortForms.joined(separator: ", ")
    }
    
    private var isConfirmButtonEnabled: Bool = false {
        willSet {
            if newValue {
                confirmButton.backgroundColor = .black
                confirmButton.isEnabled = true
            } else {
                confirmButton.backgroundColor = .gray
                confirmButton.isEnabled = false
            }
        }
    }
    
    private var isValidationMessageVisible = false {
        didSet {
            checkFromValidation()
            if isValidationMessageVisible {
                validationMessageHeightConstraint?.constant = 22
                parametersTableViewTopConstraint?.constant = 32
            } else {
                validationMessageHeightConstraint?.constant = 0
                parametersTableViewTopConstraint?.constant = 16
            }
        }
    }
    private var validationMessageHeightConstraint: NSLayoutConstraint?
    private var parametersTableViewTopConstraint: NSLayoutConstraint?
    private let parameters = ["Категория", "Расписание"]
    private let emojis = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱",
        "😇", "😡", "🥶", "🤔", "🙌", "🍔",
        "🥦", "🏓", "🥇", "🎸", "🏝", "😪",
    ]
    private let colors = UIColor.selection
    
    // MARK: - Lifecycle
    
    init(type: AddTrackerViewController.TrackerType, data: Tracker.Data = Tracker.Data()) {
        self.type = type
        self.data = data
        switch type {
        case .habit:
            self.data.schedule = []
        case .irregularEvent:
            self.data.schedule = nil
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var collectionViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeHideKeyboard()
        setupContent()
        setupConstraints()
        
        data.emoji = emojis.randomElement()
        data.color = colors.randomElement()
        
        checkFromValidation()
    }
    
    // MARK: - Actions
    
    @objc
    private func didChangedLabelTextField(_ sender: UITextField) {
        guard let text = sender.text else { return }
        data.label = text
        if text.count > 38 {
            isValidationMessageVisible = true
        } else {
            isValidationMessageVisible = false
        }
    }
    
    @objc
    private func didTapCancelButton() {
        delegate?.didTapCancelButton()
    }
    
    @objc
    private func didTapConfirmButton() {
        guard let category, let emoji = data.emoji, let color = data.color else { return }
        
        let newTracker = Tracker(
            label: data.label,
            emoji: emoji,
            color: color,
            schedule: data.schedule
        )
        
        delegate?.didTapConfirmButton(categoryLabel: category, trackerToAdd: newTracker)
    }
    
    // MARK: - Methods
    
    private func checkFromValidation() {
        if data.label.count == 0 {
            isConfirmButtonEnabled = false
            return
        }
        
        if isValidationMessageVisible {
            isConfirmButtonEnabled = false
            return
        }
        
        if category == nil || data.emoji == nil || data.color == nil {
            isConfirmButtonEnabled = false
            return
        }
        
        if let schedule = data.schedule, schedule.isEmpty {
            isConfirmButtonEnabled = false
            return
        }
        
        isConfirmButtonEnabled = true
    }
}

// MARK: - Layout methods

private extension TrackersFormViewController {
    func setupContent() {
        switch type {
        case .habit: title = "Новая привычка"
        case .irregularEvent: title = "Новое нерегулярное событие"
        }
        
        parametersTableView.dataSource = self
        parametersTableView.delegate = self
        
        view.backgroundColor = .white
        view.addSubview(textField)
        view.addSubview(validationMessage)
        view.addSubview(parametersTableView)
        view.addSubview(buttonsStack)
        buttonsStack.addArrangedSubview(cancelButton)
        buttonsStack.addArrangedSubview(confirmButton)
    }
    
    func setupConstraints() {
        validationMessageHeightConstraint = validationMessage.heightAnchor.constraint(equalToConstant: 0)
        parametersTableViewTopConstraint = parametersTableView.topAnchor.constraint(equalTo: validationMessage.bottomAnchor, constant: 16)
        validationMessageHeightConstraint?.isActive = true
        parametersTableViewTopConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: ListCellPlaceHolder.height),

            validationMessage.centerXAnchor.constraint(equalTo: textField.centerXAnchor),
            validationMessage.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 8),

            parametersTableView.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            parametersTableView.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            parametersTableView.heightAnchor.constraint(equalToConstant: data.schedule == nil ? ListCellPlaceHolder.height : 2 *  ListCellPlaceHolder.height),

            buttonsStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            buttonsStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            buttonsStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            buttonsStack.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}

// MARK: - UITableViewDataSource

extension TrackersFormViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         data.schedule == nil ?  1 :  2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let listCell = tableView.dequeueReusableCell(withIdentifier: TableViewCellPlaceHolder.identifier) as? TableViewCellPlaceHolder
        else { return UITableViewCell() }

        var position: ListCellPlaceHolder.Position
        var value: String? = nil

        if data.schedule == nil {
            position = .alone
            value = category
        } else {
            position = indexPath.row == 0 ? .first : .last
            value = indexPath.row == 0 ? category : scheduleString
        }

        listCell.configure(label: parameters[indexPath.row], value: value, position: position)
        return listCell
    }
}

// MARK: - UITableViewDelegate

extension TrackersFormViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath.row != 0) {
            guard let schedule = data.schedule else { return }
            let scheduleViewController = ScheduleViewController(selectedWeekdays: schedule)
            scheduleViewController.delegate = self
            let navigationController = UINavigationController(rootViewController: scheduleViewController)
            present(navigationController, animated: true)
        } else {
            return
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        ListCellPlaceHolder.height
    }
}

// MARK: - ScheduleViewControllerDelegate

extension TrackersFormViewController: ScheduleViewControllerDelegate {
    func didConfirm(_ schedule: [Weekday]) {
        data.schedule = schedule
        parametersTableView.reloadData()
        dismiss(animated: true)
    }
}

//MARK: - Hiding keyboard on tap

extension TrackersFormViewController {
    func initializeHideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

