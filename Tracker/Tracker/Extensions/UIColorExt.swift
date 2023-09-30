//
//  UIColorExt.swift
//  Tracker
//
//  Created by Konstantin Zuykov on 17.06.2023.
//

import UIKit

extension UIColor {
    
    static let defaultBackground = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
    static let defaultForeground = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
    
    static let appBackground = UIColor(named: "Background") ?? defaultBackground
    static let appBlack = UIColor(named: "Black") ?? defaultBackground
    static let appBlue = UIColor(named: "Blue") ?? defaultForeground
    static let appGray = UIColor(named: "Gray") ?? defaultForeground
    static let appLightGray = UIColor(named: "Light Gray") ?? defaultForeground
    static let appRed = UIColor(named: "Red") ?? defaultForeground
    static let appWhite = UIColor(named: "White") ?? defaultForeground
    
    static let selection = [
        UIColor(named: "Color selection 1") ?? defaultForeground,
        UIColor(named: "Color selection 2") ?? defaultForeground,
        UIColor(named: "Color selection 3") ?? defaultForeground,
        UIColor(named: "Color selection 4") ?? defaultForeground,
        UIColor(named: "Color selection 5") ?? defaultForeground,
        UIColor(named: "Color selection 6") ?? defaultForeground,
        UIColor(named: "Color selection 7") ?? defaultForeground,
        UIColor(named: "Color selection 8") ?? defaultForeground,
        UIColor(named: "Color selection 9") ?? defaultForeground,
        UIColor(named: "Color selection 10") ?? defaultForeground,
        UIColor(named: "Color selection 11") ?? defaultForeground,
        UIColor(named: "Color selection 12") ?? defaultForeground,
        UIColor(named: "Color selection 13") ?? defaultForeground,
        UIColor(named: "Color selection 14") ?? defaultForeground,
        UIColor(named: "Color selection 15") ?? defaultForeground,
        UIColor(named: "Color selection 16") ?? defaultForeground,
        UIColor(named: "Color selection 17") ?? defaultForeground,
        UIColor(named: "Color selection 18") ?? defaultForeground
    ]
    
    static let gradient = [
        UIColor(named: "GradientBlue")!,
        UIColor(named: "GradientGreen")!,
        UIColor(named: "GradientRed")!,
    ]
    
}
