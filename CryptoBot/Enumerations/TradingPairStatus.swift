//
//  TradingPairStatus.swift
//  Crypto Bot
//
//  Created by Andre Muis on 3/23/24.
//

import Foundation

enum TradingPairStatus: String, Decodable {
    case preLaunch = "PreLaunch"
    case trading = "Trading"
    case settling = "Settling"
    case delivering = "Delivering"
    case closed = "Closed"
}
