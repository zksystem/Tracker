//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Konstantin Zuykov on 17.06.2023.
//

import UIKit

protocol ScheduleViewControllerDelegate: AnyObject {
    func didConfirm(_ schedule: [Weekday])
}

final class ScheduleViewController: UIViewController {
    
    // MARK: - Layout elements
    
    private let weekdaysTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(WeekDayCell.self, forCellReuseIdentifier: WeekDayCell.identifier)
        table.separatorStyle = .none
        table.isScrollEnabled = true
        return table
    }()
    
    private lazy var confirmButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 335, height: 60))
        button.setTitle("Готово", for: .normal)
        button.backgroundColor = .appBlack
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.appWhite, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapConfirmButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Properties
    
    weak var delegate: ScheduleViewControllerDelegate?
    private var selectedWeekdays: Set<Weekday> = []
    
    // MARK: - Lifecycle
    
    init(selectedWeekdays: [Weekday]) {
        self.selectedWeekdays = Set(selectedWeekdays)
        super.init(nibName: nil, bundle: nil)
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
    private func didTapConfirmButton() {
        let weekdays = Array(selectedWeekdays).sorted()
        delegate?.didConfirm(weekdays)
    }
}

// MARK: - Layout methods

private extension ScheduleViewController {
    func setupContent() {
        title = "Расписание"
        view.backgroundColor = .white
        view.addSubview(weekdaysTableView)
        view.addSubview(confirmButton)
        
        weekdaysTableView.dataSource = self
        weekdaysTableView.delegate = self
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            // weekdaysTableView
            weekdaysTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            weekdaysTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            weekdaysTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            weekdaysTableView.bottomAnchor.constraint(equalTo: confirmButton.topAnchor, constant: -16),
            // confirmButton
            confirmButton.leadingAnchor.constraint(equalTo: weekdaysTableView.leadingAnchor),
            confirmButton.trailingAnchor.constraint(equalTo: weekdaysTableView.trailingAnchor),
            confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            confirmButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
}

// MARK: - UITableViewDataSource

extension ScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Weekday.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let weekDayCell = tableView.dequeueReusableCell(withIdentifier: WeekDayCell.identifier) as? WeekDayCell else { return UITableViewCell() }
        
        let weekday = Weekday.allCases[indexPath.row]
        var position: ListCellPlaceHolder.Position
        
        switch indexPath.row {
        case 0:
            position = .first
        case Weekday.allCases.count - 1:
            position = .last
        default:
            position = .middle
        }
        
        weekDayCell.configure(
            with: weekday,
            isSelected: selectedWeekdays.contains(weekday),
            position: position
        )
        weekDayCell.delegate = self
        return weekDayCell
    }
}

// MARK: - UITableViewDelegate

extension ScheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        ListCellPlaceHolder.height
    }
}

// MARK: - WeekdayCellDelegate

extension ScheduleViewController: WeekDayCellDelegate {
    func didToggleSwitchView(to isSelected: Bool, of weekday: Weekday) {
        if isSelected {
            selectedWeekdays.insert(weekday)
        } else {
            selectedWeekdays.remove(weekday)
        }
    }
}

