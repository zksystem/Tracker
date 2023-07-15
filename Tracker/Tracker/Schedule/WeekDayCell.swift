//
//  WeekDayCell.swift
//  Tracker
//
//  Created by Konstantin Zuykov on 17.06.2023.
//

import UIKit

protocol WeekDayCellDelegate: AnyObject {
    func didToggleSwitchView(to isSelected: Bool, of weekday: Weekday)
}

final class WeekDayCell: UITableViewCell {
    
    // MARK: - Properties
    
    weak var delegate: WeekDayCellDelegate?
    private var weekday: Weekday?
    static let identifier = "WeekDayCell"
    
    // MARK: - Layout elements
    
    private lazy var listItem = ListCellPlaceHolder()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    private lazy var switchView: UISwitch = {
        let switchView = UISwitch()
        switchView.translatesAutoresizingMaskIntoConstraints = false
        switchView.onTintColor = .blue
        switchView.addTarget(self, action: #selector(didToggleSwitchView), for: .valueChanged)
        return switchView
    }()
    

    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupContent()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc
    private func didToggleSwitchView(_ sender: UISwitch) {
        guard let weekday else { return }
        delegate?.didToggleSwitchView(to: sender.isOn, of: weekday)
    }
    
    // MARK: - Methods
    
    func configure(with weekday: Weekday, isSelected: Bool, position: ListCellPlaceHolder.Position) {
        self.weekday = weekday
        listItem.configure(with: position)
        nameLabel.text = weekday.rawValue
        switchView.isOn = isSelected
    }
}

private extension WeekDayCell {
    func setupContent() {
        selectionStyle = .none
        contentView.addSubview(listItem)
        contentView.addSubview(nameLabel)
        contentView.addSubview(switchView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            // listItem
            listItem.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            listItem.topAnchor.constraint(equalTo: contentView.topAnchor),
            listItem.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            listItem.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            // labelsStack
            nameLabel.leadingAnchor.constraint(equalTo: listItem.leadingAnchor, constant: 16),
            nameLabel.centerYAnchor.constraint(equalTo: listItem.centerYAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: listItem.trailingAnchor, constant: -83),
            // switchView
            switchView.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            switchView.trailingAnchor.constraint(equalTo: listItem.trailingAnchor, constant: -16)
        ])
    }
}

