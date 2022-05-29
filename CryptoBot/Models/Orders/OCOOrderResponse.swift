//
//  OCOOrderResponse.swift
//  Crypto Bot
//
//  Created by Andre Muis on 5/22/22.
//

import Foundation

struct OCOOrderResponse: Decodable {
    let marketPairSymbol: String
    let listOrderStatus: ListOrderStatus
    let orderReports: [OCOOrderReport]

    enum CodingKeys: String, CodingKey {
        case marketPairSymbol = "symbol"
        case listOrderStatus = "listOrderStatus"
        case orderReports = "orderReports"
    }
}
