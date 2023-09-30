//
//  TabBarController.swift
//  Tracker
//
//  Created by Konstantin Zuykov on 17.06.2023.
//

import UIKit

enum Tabs: Int {
    case tracker
    case statistic
}

final class TabBarController: UITabBarController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        tabBar.tintColor = .appBlue
        tabBar.barTintColor = .appGray
        tabBar.backgroundColor = .appWhite
        
        let trackerViewController = TrackersViewController(trackerStore: TrackerStore())
        let statisticViewController = StatisticsViewController()
        let statisticsViewModel = StatisticsViewModel()
        statisticViewController.statisticsViewModel = statisticsViewModel
        

        trackerViewController.tabBarItem = UITabBarItem(
            title: Resources.Strings.TabBar.tracker,
            image: Resources.Images.TabBar.tracker,
            tag: Tabs.tracker.rawValue)
        statisticViewController.tabBarItem = UITabBarItem(
            title: Resources.Strings.TabBar.statistics,
            image: Resources.Images.TabBar.statistics,
            tag: Tabs.statistic.rawValue)

        let controllers = [trackerViewController,
                           statisticViewController]

        viewControllers = controllers
    }
    
}
