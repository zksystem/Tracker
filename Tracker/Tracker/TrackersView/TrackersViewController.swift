//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Konstantin Zuykov on 31.05.2023.
//

import Foundation
import UIKit

class TrackersViewController : UIViewController {
    
    // MARK: View did load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initComponents()
    }
    
    // MARK: add button definition
    
    private lazy var addButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(systemName: "plus",
                          withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .bold))!,
            target: self,
            action: #selector(didTapAddButton)
        )
        button.tintColor = UIColor(named: "Black")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: addButton action
    
    @objc
    private func didTapAddButton() {
        //TODO: add code here
    }
    
    // MARK: title label definition
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Трекеры"
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textColor = UIColor(named: "Black")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: status label definition
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor(named: "Black")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: status imageView definition
    
    private let statusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Error")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: datePicker definition
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.backgroundColor = UIColor(named: "White")
        datePicker.tintColor = UIColor(named: "Blue")
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.calendar = Calendar(identifier: .iso8601)
        datePicker.maximumDate = Date()
        
        if let currentLocale = Locale.current.languageCode {
            datePicker.locale = Locale(identifier: currentLocale)
        } else {
            datePicker.locale = Locale(identifier: "ru_RU")
        }
        
        datePicker.addTarget(self, action: #selector(didDatePicked), for: .valueChanged)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
    // MARK: datePicker action
    
    @objc
    private func didDatePicked(_ sender: UIDatePicker) {
        //TODO: add code here
    }
    
    // MARK: search bar
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Поиск"
        searchBar.searchBarStyle = .minimal
        //searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    // MARK: error stack
    
    private let statusStack: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: Layout
    
    func initComponents() {
        view.backgroundColor = UIColor(named: "White")
        
        view.addSubview(addButton)
        view.addSubview(titleLabel)
        view.addSubview(datePicker)
        view.addSubview(searchBar)
        view.addSubview(statusStack)
        
        statusStack.addArrangedSubview(statusImageView)
        statusStack.addArrangedSubview(statusLabel)
        
        // Constraints
        
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 13),
            addButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 13),
            
            datePicker.widthAnchor.constraint(equalToConstant: 120),
            datePicker.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            datePicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            
            statusStack.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            statusStack.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
        
        
    }
    
    
}