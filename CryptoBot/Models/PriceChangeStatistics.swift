//
//  PriceChangeStatistics.swift
//  Crypto Bot
//
//  Created by Andre Muis on 4/30/22.
//

import Foundation

struct PriceChangeStatistics: Decodable {
    let marketPairSymbol: String
    let priceChangePercent: Decimal
    let volume: Decimal

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.marketPairSymbol = try container.decode(String.self, forKey: .marketPairSymbol)
        self.priceChangePercent = try container.decimalFromString(codingKey: .priceChangePercent)
        self.volume = try container.decimalFromString(codingKey: .volume)
    }

    enum CodingKeys: String, CodingKey {
        case marketPairSymbol = "symbol"
        case priceChangePercent = "priceChangePercent"
        case volume = "volume"
    }
}
