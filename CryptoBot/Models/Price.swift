//
//  Price.swift
//  CryptoBot
//
//  Created by Andre Muis on 4/24/22.
//

import Foundation

struct Price: Decodable {
    let marketPairSymbol: String
    let amount: Decimal

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.marketPairSymbol = try container.decode(String.self, forKey: .marketPairSymbol)
        self.amount = try container.decimalFromString(codingKey: .amount)
    }

    enum CodingKeys: String, CodingKey {
        case marketPairSymbol = "symbol"
        case amount = "price"
    }
}
