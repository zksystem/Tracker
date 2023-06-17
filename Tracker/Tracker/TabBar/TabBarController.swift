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
        tabBar.tintColor = UIColor(named: "Blue")
        tabBar.barTintColor = UIColor(named: "Gray")
        tabBar.backgroundColor = UIColor(named: "White")
        
        tabBar.layer.borderColor = UIColor(named: "Gray")?.cgColor
        tabBar.layer.borderWidth = 1
        tabBar.layer.masksToBounds = true
        
        let trackerViewController = TrackersViewController()
        let statisticViewController = StatisticsViewController()

        trackerViewController.tabBarItem = UITabBarItem(
            title: Resources.Strings.TabBar.tracker,
            image: Resources.Images.TabBar.tracker,
            tag: Tabs.tracker.rawValue)
        statisticViewController.tabBarItem = UITabBarItem(
            title: Resources.Strings.TabBar.statistic,
            image: Resources.Images.TabBar.statistic,
            tag: Tabs.statistic.rawValue)

        let controllers = [trackerViewController,
                           statisticViewController]

        viewControllers = controllers
    }
    
}
