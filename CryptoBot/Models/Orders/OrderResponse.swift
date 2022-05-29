//
//  OrderResponse.swift
//  CryptoBot
//
//  Created by Andre Muis on 4/25/22.
//

import Foundation

struct OrderResponse: Decodable {
    let marketPairSymbol: String
    let type: OrderType
    let side: OrderSide
    let cummulativeQuoteQuantity: Decimal
    let executedQuantity: Decimal
    let status: OrderStatus

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.marketPairSymbol = try container.decode(String.self, forKey: .marketPairSymbol)
        self.type = try container.decode(OrderType.self, forKey: .type)
        self.side = try container.decode(OrderSide.self, forKey: .side)
        self.cummulativeQuoteQuantity = try container.decimalFromString(codingKey: .cummulativeQuoteQuantity)
        self.executedQuantity = try container.decimalFromString(codingKey: .executedQuantity)
        self.status = try container.decode(OrderStatus.self, forKey: .status)
    }

    enum CodingKeys: String, CodingKey {
        case marketPairSymbol = "symbol"
        case type = "type"
        case side = "side"
        case cummulativeQuoteQuantity = "cummulativeQuoteQty"
        case executedQuantity = "executedQty"
        case status = "status"
    }
}
