//
//  DateExt.swift
//  Tracker
//
//  Created by Konstantin Zuykov on 17.06.2023.
//

import Foundation

extension Date {
    static func from(year: Int, month: Int, day: Int) -> Date? {
        let calendar = Calendar(identifier: .gregorian)
        var dateComponents = DateComponents()
        dateComponents.day = day
        dateComponents.month = month
        dateComponents.year = year
        return calendar.date(from: dateComponents)
    }
    
    static func from(date: Date) -> Date? {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: date)

        guard let day = components.day,
              let month = components.month,
              let year = components.year else {
            return nil
        }
        return from(year: year, month: month, day: day)
    }
}
