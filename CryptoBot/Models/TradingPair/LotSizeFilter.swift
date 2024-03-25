//
//  LotSizeFilter.swift
//  Crypto Bot
//
//  Created by Andre Muis on 3/24/24.
//

import Foundation

struct LotSizeFilter: Decodable {
    let quotePrecision: Decimal
    let minOrderAmount: Decimal

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.quotePrecision = try container.decimalFromString(codingKey: .quotePrecision)
        self.minOrderAmount = try container.decimalFromString(codingKey: .minOrderAmount)
    }

    enum CodingKeys: String, CodingKey {
        case quotePrecision = "quotePrecision"
        case minOrderAmount = "minOrderAmt"
    }
}
