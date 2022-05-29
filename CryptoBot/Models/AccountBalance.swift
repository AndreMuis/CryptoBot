//
//  AccountBalance.swift
//  CryptoBot
//
//  Created by Andre Muis on 4/24/22.
//

import Foundation

struct AccountBalance: Decodable {
    let asset: String
    let free: Decimal

    var marketPairSymbol: String {
        return "\(self.asset)\(Constants.quoteAssetSymbol)"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.asset = try container.decode(String.self, forKey: .asset)
        self.free = try container.decimalFromString(codingKey: .free)
    }

    enum CodingKeys: String, CodingKey {
        case asset = "asset"
        case free = "free"
    }
}
