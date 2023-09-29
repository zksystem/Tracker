//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Konstantin Zuykov on 17.06.2023.
//

import UIKit

final class StatisticsViewController: UIViewController {
    
    // MARK: - Layout elements
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("tab_statistics", tableName: "Localizable", comment: "tab_statistics")
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        return label
    }()
    
    private let emptyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = Resources.Images.Error.statistics
        return imageView
    }()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.text = NSLocalizedString("noghing_to_analyze", tableName: "Localizable", comment: "noghing_to_analyze") //"Анализировать пока нечего"
        label.textColor = .appBlack
        return label
    }()
    
    private let emptyStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 8
        return stack
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContent()
        setupConstraints()
    }
}

// MARK: - Layout methods

private extension StatisticsViewController {
    func setupContent() {
        view.backgroundColor = .appWhite
        view.addSubview(titleLabel)
        view.addSubview(emptyStack)
        
        emptyStack.addArrangedSubview(emptyImageView)
        emptyStack.addArrangedSubview(emptyLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            // titleLabel
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 52),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            //emptyStack
            emptyStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

