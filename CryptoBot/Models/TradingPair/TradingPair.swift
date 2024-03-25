//
//  TradingPair.swift
//  Crypto Bot
//
//  Created by Andre Muis on 5/28/22.
//

import Foundation

struct TradingPair: Decodable {
    let symbol: String
    private let status: TradingPairStatus
    let baseCoin: String
    let quoteCoin: String
    let lotSizeFilter: LotSizeFilter

    var canTrade: Bool {
        return self.status == .trading
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.symbol = try container.decode(String.self, forKey: .symbol)
        self.status = try container.decode(TradingPairStatus.self, forKey: .status)
        self.baseCoin = try container.decode(String.self, forKey: .baseCoin)
        self.quoteCoin = try container.decode(String.self, forKey: .quoteCoin)
        self.lotSizeFilter = try container.decode(LotSizeFilter.self, forKey: .lotSizeFilter)
    }

    enum CodingKeys: String, CodingKey {
        case symbol = "symbol"
        case status = "status"
        case baseCoin = "baseCoin"
        case quoteCoin = "quoteCoin"
        case lotSizeFilter = "lotSizeFilter"
    }
}
