//
//  AccountCoin.swift
//  Crypto Bot
//
//  Created by Andre Muis on 3/24/24.
//

import Foundation

struct AccountCoin: Decodable {
    let symbol: String
    let free: Decimal
    let locked: Decimal

    var tradingPairSymbol: String {
        return "\(self.symbol)\(Constants.quoteSymbol)"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.symbol = try container.decode(String.self, forKey: .symbol)
        self.free = try container.decimalFromString(codingKey: .free)
        self.locked = try container.decimalFromString(codingKey: .locked)
    }

    enum CodingKeys: String, CodingKey {
        case symbol = "coin"
        case free = "walletBalance"
        case locked = "locked"
    }
}
