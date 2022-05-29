//
//  Trade.swift
//  CryptoBot
//
//  Created by Andre Muis on 4/28/22.
//

import Foundation

struct Trade: Decodable, Hashable {
    var marketPairSymbol: String
    var price: Decimal
    var quantity: Decimal
    var quoteQuantity: Decimal
    var isBuyer: Bool
    var isMaker: Bool

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.marketPairSymbol = try container.decode(String.self, forKey: .marketPairSymbol)
        self.price = try container.decimalFromString(codingKey: .price)
        self.quantity = try container.decimalFromString(codingKey: .quantity)
        self.quoteQuantity = try container.decimalFromString(codingKey: .quoteQuantity)
        self.isBuyer = try container.decode(Bool.self, forKey: .isBuyer)
        self.isMaker = try container.decode(Bool.self, forKey: .isMaker)
    }

    enum CodingKeys: String, CodingKey {
        case marketPairSymbol = "symbol"
        case price = "price"
        case quantity = "qty"
        case quoteQuantity = "quoteQty"
        case isBuyer = "isBuyer"
        case isMaker = "isMaker"
    }
}
