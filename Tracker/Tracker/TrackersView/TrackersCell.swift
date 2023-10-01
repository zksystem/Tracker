//
//  TrackersCell.swift
//  Tracker
//
//  Created by Konstantin Zuykov on 12.06.2023.
//

import UIKit

protocol TrackersCellDelegate: AnyObject {
    func didTapCompleteButton(of cell: TrackersCell, with tracker: Tracker)
}


final class TrackersCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    private let analytics = Analytics()
    
    static let identifier = "TrackerCell"
    weak var delegate: TrackersCellDelegate?
    private var tracker: Tracker?
    private var days = 0 {
        willSet {
            daysCountLabel.text = String.localizedStringWithFormat(NSLocalizedString("numberOfDays", comment: "Number of days"), newValue)
        }
    }
    
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContent()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        tracker = nil
        days = 0
        completeButton.setImage(UIImage(systemName: "plus"), for: .normal)
        completeButton.layer.opacity = 1
    }
    
    // MARK: - Methods
    
    func configure(with tracker: Tracker, days: Int, isCompleted: Bool, interaction: UIInteraction) {
        self.tracker = tracker
        self.days = days
        cardView.backgroundColor = tracker.color
        emoji.text = tracker.emoji
        trackerLabel.text = tracker.label
        completeButton.backgroundColor = tracker.color
        contentView.addInteraction(interaction)
        pinImageView.isHidden = !tracker.isPinned
        toggleCompletedButton(to: isCompleted)
    }
    
    func toggleCompletedButton(to isCompleted: Bool) {
        if isCompleted {
            completeButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
            completeButton.layer.opacity = 0.3
        } else {
            completeButton.setImage(UIImage(systemName: "plus"), for: .normal)
            completeButton.layer.opacity = 1
        }
    }
    
    func increaseCount() {
        days += 1
    }
    
    func decreaseCount() {
        days -= 1
    }
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    //MARK: cardView
    
    private let cardView: UIView = {
        let uiView = UIView()
        uiView.layer.borderWidth = 1
        uiView.layer.cornerRadius = 16
        uiView.layer.borderColor = UIColor(red: 174 / 255, green: 175 / 255, blue: 180 / 255, alpha: 0.3).cgColor
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()

    private let emoji: UILabel = {
        let uiLabel = UILabel()
        uiLabel.translatesAutoresizingMaskIntoConstraints = false
        uiLabel.font = UIFont.systemFont(ofSize: 12)
        return uiLabel
    }()

    private let iconView: UIView = {
        let uiView = UIView()
        uiView.layer.cornerRadius = 12
        uiView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3)
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    
    private let trackerLabel: UILabel = {
        let uiLabel = UILabel()
        uiLabel.numberOfLines = 0
        uiLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        uiLabel.textColor = UIColor(named: "White")
        uiLabel.translatesAutoresizingMaskIntoConstraints = false
        return uiLabel
    }()
    
    private let daysCountLabel: UILabel = {
        let uiLabel = UILabel()
        uiLabel.translatesAutoresizingMaskIntoConstraints = false
        uiLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        uiLabel.textColor = UIColor(named: "Black")
        return uiLabel
    }()
    
    private lazy var completeButton: UIButton = {
        let uiButton = UIButton(type: .custom)
        uiButton.setImage(UIImage(systemName: "plus"), for: .normal)
        uiButton.tintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        uiButton.layer.cornerRadius = 16
        uiButton.addTarget(self, action: #selector(didTapCompleteButton), for: .touchUpInside)
        uiButton.translatesAutoresizingMaskIntoConstraints = false
        return uiButton
    }()
    
    private let pinImageView: UIImageView = {
            let image = UIImageView()
            image.image = UIImage(named: "Pin")
            image.isHidden = false
            image.translatesAutoresizingMaskIntoConstraints = false
            return image
        }()
    

    
    //MARK: complete button callback
    
    @objc
    private func didTapCompleteButton() {
        analytics.report(event: "click", params: ["screen": "Main", "item": "track"]) /* analytics */
        guard let tracker else { return }
        delegate?.didTapCompleteButton(of: self, with: tracker)
    }
}

// MARK: Layout

private extension TrackersCell {
    func setupContent() {
        contentView.addSubview(cardView)
        contentView.addSubview(iconView)
        contentView.addSubview(pinImageView)
        contentView.addSubview(emoji)
        contentView.addSubview(trackerLabel)
        contentView.addSubview(daysCountLabel)
        contentView.addSubview(completeButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.heightAnchor.constraint(equalToConstant: 90),

            iconView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            iconView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            iconView.widthAnchor.constraint(equalToConstant: 24),
            iconView.heightAnchor.constraint(equalTo: iconView.widthAnchor),
            
            pinImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            pinImageView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 18),
            pinImageView.widthAnchor.constraint(equalToConstant: 8),
            pinImageView.heightAnchor.constraint(equalToConstant: 12),

            emoji.centerXAnchor.constraint(equalTo: iconView.centerXAnchor),
            emoji.centerYAnchor.constraint(equalTo: iconView.centerYAnchor),

            trackerLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            trackerLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            trackerLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),

            daysCountLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            daysCountLabel.centerYAnchor.constraint(equalTo: completeButton.centerYAnchor),
            daysCountLabel.trailingAnchor.constraint(equalTo: completeButton.leadingAnchor, constant: -8),

            completeButton.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 8),
            completeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            completeButton.widthAnchor.constraint(equalToConstant: 34),
            completeButton.heightAnchor.constraint(equalTo: completeButton.widthAnchor),
        ])
    }
}


