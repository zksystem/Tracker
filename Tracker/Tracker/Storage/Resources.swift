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
            static var statistic = "Статистика"
            static var tracker = "Трекеры"
        }
    }
    
    enum Images {
        enum TabBar {
            static var statistic = UIImage(named: "Statistics")
            static var tracker = UIImage(named: "Trackers")
        }
        enum Error {
            static var errorTracker = UIImage(named: "TrackersError")
            static var errorStatistic = UIImage(named: "StatisticsError")
        }
        enum Empty {
            static var emptyTracker = UIImage(named: "Error")
        }
    }
}
