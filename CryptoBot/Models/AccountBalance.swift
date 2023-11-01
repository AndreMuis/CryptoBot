//
//  AccountBalance.swift
//  CryptoBot
//
//  Created by Andre Muis on 4/24/22.
//

import Foundation

struct AccountBalance: Decodable {
    let symbol: String
    let free: Decimal
    let locked: Decimal

    var marketPairSymbol: String {
        return "\(self.symbol)\(Constants.quoteSymbol)"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.symbol = try container.decode(String.self, forKey: .asset)
        self.free = try container.decimalFromString(codingKey: .free)
        self.locked = try container.decimalFromString(codingKey: .locked)
    }

    enum CodingKeys: String, CodingKey {
        case asset = "asset"
        case free = "free"
        case locked = "locked"
    }
}
