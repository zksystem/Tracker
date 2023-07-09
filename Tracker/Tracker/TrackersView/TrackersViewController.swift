//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Konstantin Zuykov on 31.05.2023.
//

import Foundation
import UIKit

class TrackersViewController : UIViewController {
    
    // MARK: - Variables
    
    private let params = UICollectionView.GeometricParams(cellCount: 2, leftInset: 16, rightInset: 16, cellSpacing: 10)
    private var categories: [TrackerCategory] = TrackerCategory.sampleData
    private var searchText = ""
    private var currentDate = Date.from(date: Date())!
    private var completedTrackers: Set<TrackerRecord> = []
    
    private var visibleCategories: [TrackerCategory]
    {
        let weekday = Calendar.current.component(.weekday, from: currentDate)
        
        var result = [TrackerCategory]()
        for category in categories {
            let trackersByDay = category.trackers.filter { tracker in
                guard let schedule = tracker.schedule else { return true }
                return schedule.contains(Weekday.allCases[weekday > 1 ? weekday - 2 : weekday + 5])
            }
            
            if searchText.isEmpty && !trackersByDay.isEmpty {
                result.append(TrackerCategory(label: category.label, trackers: trackersByDay))
            } else {
                let filteredTrackers = trackersByDay.filter { tracker in
                    tracker.label.lowercased().contains(searchText.lowercased())
                }
                
                if !filteredTrackers.isEmpty {
                    result.append(TrackerCategory(label: category.label, trackers: filteredTrackers))
                }
            }
        }
        
        if result.isEmpty {
            statusStack.isHidden = false
            filterButton.isHidden = true
        } else {
            statusStack.isHidden = true
            filterButton.isHidden = false
        }
        
        return result
    }
    
    
    // MARK: - View did load
    
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
        button.tintColor = .appBlack
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - AddButton action
    
    @objc
    private func didTapAddButton() {
        let addTrackerViewController = AddTrackerViewController()
        addTrackerViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: addTrackerViewController)
        present(navigationController, animated: true)
    }
    
    //MARK: - ChangeDatePicker
    
    @objc
    private func didChangedDatePicker(_ sender: UIDatePicker) {
        currentDate = Date.from(date: sender.date)!
        collectionView.reloadData()
    }
    
    // MARK: - Title label definition
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Трекеры"
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textColor = .appBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Status label definition
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .appBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: status imageView definition
    
    private let statusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Resources.Images.Empty.emptyTracker
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: datePicker definition
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.backgroundColor = .appWhite
        datePicker.tintColor = .appBlue
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
    
    // MARK: DatePicker action
    
    @objc
    private func didDatePicked(_ sender: UIDatePicker) {
        currentDate = Date.from(date: sender.date)!
        collectionView.reloadData()
    }
    
    // MARK: Search bar
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Поиск"
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    // MARK: Error stack
    
    private let statusStack: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: Filter button
    
    private lazy var filterButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Фильтры", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.tintColor = .appBlue
        button.layer.cornerRadius = 16
        button.backgroundColor = .appBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    // MARK: collection view
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .appWhite
        
        collectionView.register(
            TrackersCell.self,
            forCellWithReuseIdentifier: TrackersCell.identifier
        )
        
        collectionView.register(
            TrackersCategoryLabel.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "header"
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    
    // MARK: Layout
    
    func initComponents() {
        view.backgroundColor = .appWhite
        
        view.addSubview(addButton)
        view.addSubview(titleLabel)
        view.addSubview(datePicker)
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        view.addSubview(statusStack)
        view.addSubview(filterButton)
        
        statusStack.addArrangedSubview(statusImageView)
        statusStack.addArrangedSubview(statusLabel)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
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
            
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            statusStack.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            statusStack.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            
            filterButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            filterButton.widthAnchor.constraint(equalToConstant: 114),
            filterButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        
    }
}

// MARK: - UISearchBarDelegate

extension TrackersViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        collectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.endEditing(true)
        searchBar.setShowsCancelButton(false, animated: true)
        self.searchText = ""
        collectionView.reloadData()
    }
}

// MARK: - AddTrackerViewControllerDelegate

extension TrackersViewController: AddTrackerViewControllerDelegate {
    func didSelectTracker(with type: AddTrackerViewController.TrackerType) {
        dismiss(animated: true)
        let trackersFormViewController = TrackersFormViewController(type: type)
        trackersFormViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: trackersFormViewController)
        present(navigationController, animated: true)
    }
}

// MARK: - TrackerCellDelegate

extension TrackersViewController: TrackersCellDelegate {
    func didTapCompleteButton(of cell: TrackersCell, with tracker: Tracker) {
        let trackerRecord = TrackerRecord(trackerId: tracker.id, date: currentDate)
        
        if completedTrackers.contains(where: { $0.date == currentDate && $0.trackerId == tracker.id }) {
            completedTrackers.remove(trackerRecord)
            cell.toggleCompletedButton(to: false)
            cell.decreaseCount()
        } else {
            completedTrackers.insert(trackerRecord)
            cell.toggleCompletedButton(to: true)
            cell.increaseCount()
        }
    }
}

// MARK: - TrackerFormViewControllerDelegate

extension TrackersViewController: TrackersFormViewControllerDelegate {
    func didTapConfirmButton(categoryLabel: String, trackerToAdd: Tracker) {
        dismiss(animated: true)
        guard let categoryIndex = categories.firstIndex(where: { $0.label == categoryLabel }) else { return }
        let updatedCategory = TrackerCategory(
            label: categoryLabel,
            trackers: categories[categoryIndex].trackers + [trackerToAdd]
        )
        categories[categoryIndex] = updatedCategory
        collectionView.reloadData()
    }
    
    func didTapCancelButton() {
        dismiss(animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        visibleCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visibleCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let trackerCell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackersCell.identifier, for: indexPath) as? TrackersCell else {
            return UICollectionViewCell()
        }
        
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.row]
        let daysCount = completedTrackers.filter { $0.trackerId == tracker.id }.count
        let isCompleted = completedTrackers.contains { $0.date == currentDate && $0.trackerId == tracker.id }
        trackerCell.configure(with: tracker, days: daysCount, isCompleted: isCompleted)
        trackerCell.delegate = self
        
        return trackerCell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let availableSpace = collectionView.frame.width - params.paddingWidth
        let cellWidth = availableSpace / params.cellCount
        return CGSize(width: cellWidth, height: 148)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int) -> UIEdgeInsets
    {
        UIEdgeInsets(top: 8, left: params.leftInset, bottom: 16, right: params.rightInset)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath) -> UICollectionReusableView
    {
        guard
            kind == UICollectionView.elementKindSectionHeader,
            let view = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: "header",
                for: indexPath
            ) as? TrackersCategoryLabel
        else { return UICollectionReusableView() }
        
        let label = visibleCategories[indexPath.section].label
        view.configure(with: label)
        
        return view
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int) -> CGSize
    {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(
            collectionView,
            viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader,
            at: indexPath
        )
        
        return headerView.systemLayoutSizeFitting(
            CGSize(
                width: collectionView.frame.width,
                height: UIView.layoutFittingExpandedSize.height
            ),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
    }
}
