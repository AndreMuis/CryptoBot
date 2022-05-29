//
//  OrderType.swift
//  CryptoBot
//
//  Created by Andre Muis on 4/25/22.
//

import Foundation

enum OrderType: String, Decodable {
    case limit = "LIMIT"
    case market = "MARKET"
    case stopLoss = "STOP_LOSS"
    case stopLossLimit = "STOP_LOSS_LIMIT"
    case takeProfit = "TAKE_PROFIT"
    case takeProfitLimit = "TAKE_PROFIT_LIMIT"
    case limitMaker = "LIMIT_MAKER"
}
