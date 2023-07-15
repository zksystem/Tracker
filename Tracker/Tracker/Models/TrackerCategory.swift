//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Konstantin Zuykov on 17.06.2023.
//

import UIKit

struct TrackerCategory {
    let id: UUID
    let label: String
    
    init(id: UUID = UUID(), label: String) {
        self.id = id
        self.label = label
    }
}
