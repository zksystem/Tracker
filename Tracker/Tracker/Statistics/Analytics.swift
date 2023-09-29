//
//  YandexAnalyticsService.swift
//  Tracker
//
//  Created by Konstantin Zuykov on 29.09.2023.
//

import Foundation
import YandexMobileMetrica

struct Analytics {
    static func setup() {
        guard let config = YMMYandexMetricaConfiguration(apiKey: "api key") else {
            return
        }
        YMMYandexMetrica.activate(with: config)
    }
    
    func report(event: String, params: [AnyHashable: Any]) {
        YMMYandexMetrica.reportEvent(event, parameters: params) {
            error in print("Report event error: %@", error.localizedDescription)
        }
    }
    
}
