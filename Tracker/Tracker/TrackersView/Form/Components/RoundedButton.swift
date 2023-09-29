//
//  RoundedButton.swift
//  Tracker
//
//  Created by Konstantin Zuykov on 17.06.2023.
//

import UIKit

final class RoundedButton: UIButton {
    convenience init(color: UIColor = .appBlack, titleColor: UIColor = .appWhite, title: String) {
        self.init(type: .system)
        
        setTitle(title, for: .normal)
        backgroundColor = color
        
        translatesAutoresizingMaskIntoConstraints = false
        setTitleColor(titleColor, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        layer.cornerRadius = 16
    }
}

extension RoundedButton {
    static func redButton(title: String) -> Self {
        let button = self.init(color: .clear, title: title)
        
        button.setTitleColor(.appRed, for: .normal)
        button.layer.borderColor = UIColor(named: "Red")?.cgColor
        button.layer.borderWidth = 1
        
        return button
    }
}
