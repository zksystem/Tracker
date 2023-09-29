//
//  Resources.swift
//  Tracker
//
//  Created by Konstantin Zuykov on 17.06.2023.
//

import Foundation

import UIKit

enum Resources {
    
    enum Strings {
        enum TabBar {
            static var statistics = NSLocalizedString("tab_statistics", tableName: "Localizable", comment: "tab_statistics")
            static var tracker = NSLocalizedString("tab_trackers", tableName: "Localizable", comment: "tab_trackers")
        }
    }
    
    enum Images {
        enum TabBar {
            static var statistics = UIImage(named: "Statistics")
            static var tracker = UIImage(named: "Trackers")
        }
        enum Error {
            static var statistics = UIImage(named: "StatisticsError")
            static var tracker = UIImage(named: "TrackersError")
        }
        enum Empty {
            static var emptyTracker = UIImage(named: "Error")
        }
    }
}
