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
    
    private let notFoundStack = NotFoundStack(
        label: NSLocalizedString("noghing_to_analyze", tableName: "Localizable", comment: "noghing_to_analyze"),
        image: UIImage(named: "StatisticsError")
    )

    private let statisticsStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        return stack
    }()
    
    private let completedTrackersView = StatisticsView(name: "Трекеров завершено")
    
    // MARK: - Properties
    
    var statisticsViewModel: StatisticsViewModel?
    private let trackerRecordStore = TrackerRecordStore()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupContent()
        setupConstraints()
        
        statisticsViewModel?.onTrackersChange = { [weak self] trackers in
            guard let self else { return }
            self.checkContent(with: trackers)
            self.setupCompletedTrackersBlock(with: trackers.count)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        statisticsViewModel?.viewWillAppear()
    }
    
    // MARK: - Private
    
    private func checkContent(with trackers: [TrackerRecord]) {
        if trackers.isEmpty {
            notFoundStack.isHidden = false
            statisticsStack.isHidden = true
        } else {
            notFoundStack.isHidden = true
            statisticsStack.isHidden = false
        }
    }
    
    private func setupCompletedTrackersBlock(with count: Int) {
        completedTrackersView.setNumber(count)
    }

}

// MARK: - Layout methods

private extension StatisticsViewController {
    
    func setupContent() {
        view.backgroundColor = .appWhite
        view.addSubview(titleLabel)
        view.addSubview(notFoundStack)
        view.addSubview(statisticsStack)
        statisticsStack.addArrangedSubview(completedTrackersView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),

            notFoundStack.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            notFoundStack.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),

            statisticsStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            statisticsStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            statisticsStack.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
}

