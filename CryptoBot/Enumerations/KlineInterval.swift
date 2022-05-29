//
//  KlineInterval.swift
//  Crypto Bot
//
//  Created by Andre Muis on 5/21/22.
//

import Foundation

enum KlineInterval: String {
    case oneMinute = "1m"
    case threeMinutes = "3m"
    case fiveMinutes = "5m"
    case fifteenMinutes = "15m"
    case thirtyMinutes = "30m"
    case oneHour = "1h"
    case twoHours = "2h"
    case fourHours = "4h"
    case sixHours = "6h"
    case eightHours = "8h"
    case twelveHours = "12h"
    case oneDay = "1d"
    case threeDays = "3d"
    case oneWeek = "1w"
    case oneMonth = "1M"

    var durationInSeconds: Int {
        switch self {
        case .oneMinute:
            return 60

        case .threeMinutes:
            return 180

        case .fiveMinutes:
            return 300

        case .fifteenMinutes:
            return 900

        case .thirtyMinutes:
            return 1800

        case .oneHour:
            return 3600

        case .twoHours:
            return 7200

        case .fourHours:
            return 14400

        case .sixHours:
            return 21600

        case .eightHours:
            return 28800

        case .twelveHours:
            return 43200

        case .oneDay:
            return 86400

        case .threeDays:
            return 259200

        case .oneWeek:
            return 604800

        case .oneMonth:
            return 2629757
        }
    }

    static let tradableIntervals = [
        KlineInterval.fiveMinutes,
        KlineInterval.fifteenMinutes,
        KlineInterval.thirtyMinutes,
        KlineInterval.oneHour]
}
