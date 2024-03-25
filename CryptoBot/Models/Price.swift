//
//  Price.swift
//  CryptoBot
//
//  Created by Andre Muis on 4/24/22.
//

import Foundation

struct Price: Decodable {
    let tradingPairSymbol: String
    let lastPrice: Decimal

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.tradingPairSymbol = try container.decode(String.self, forKey: .tradingPairSymbol)
        self.lastPrice = try container.decimalFromString(codingKey: .lastPrice)
    }

    enum CodingKeys: String, CodingKey {
        case tradingPairSymbol = "symbol"
        case lastPrice = "lastPrice"
    }
}
