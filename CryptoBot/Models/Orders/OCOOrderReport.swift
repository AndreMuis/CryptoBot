//
//  OCOOrderReport.swift
//  Crypto Bot
//
//  Created by Andre Muis on 5/22/22.
//

import Foundation

struct OCOOrderReport: Decodable {
    let marketPairSymbol: String
    let type: OrderType
    let side: OrderSide
    let timeInForce: TimeInForce
    let originalQuantity: Decimal
    let price: Decimal
    let stopPrice: Decimal?
    let status: OrderStatus

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.marketPairSymbol = try container.decode(String.self, forKey: .marketPairSymbol)
        self.type = try container.decode(OrderType.self, forKey: .type)
        self.side = try container.decode(OrderSide.self, forKey: .side)
        self.timeInForce = try container.decode(TimeInForce.self, forKey: .timeInForce)
        self.originalQuantity = try container.decimalFromString(codingKey: .originalQuantity)
        self.price = try container.decimalFromString(codingKey: .price)

        if container.contains(.stopPrice) {
            self.stopPrice = try container.decimalFromString(codingKey: .stopPrice)
        } else {
            self.stopPrice = nil
        }

        self.status = try container.decode(OrderStatus.self, forKey: .status)
    }

    enum CodingKeys: String, CodingKey {
        case marketPairSymbol = "symbol"
        case type = "type"
        case side = "side"
        case timeInForce = "timeInForce"
        case originalQuantity = "origQty"
        case price = "price"
        case stopPrice = "stopPrice"
        case status = "status"
    }
}
