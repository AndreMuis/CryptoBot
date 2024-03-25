//
//  OrderType.swift
//  CryptoBot
//
//  Created by Andre Muis on 4/25/22.
//

import Foundation

enum OrderType: String, Decodable {
    case limit = "Limit"
    case market = "Market"
}
