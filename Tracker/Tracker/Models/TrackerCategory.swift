//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Konstantin Zuykov on 17.06.2023.
//

import UIKit

struct TrackerCategory {
    let label: String
    let trackers: [Tracker]
    
    init(label: String, trackers: [Tracker]) {
        self.label = label
        self.trackers = trackers
    }
}

extension TrackerCategory {
    static let sampleData: [TrackerCategory] = [
        TrackerCategory(
            label: "Домашний уют",
            trackers: []
        ),
        TrackerCategory(
            label: "Радостные мелочи",
            trackers: []
        )
    ]
}
