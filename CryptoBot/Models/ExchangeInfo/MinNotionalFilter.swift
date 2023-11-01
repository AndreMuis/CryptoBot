//
//  MinNotionalFilter.swift
//  Crypto Bot
//
//  Created by Andre Muis on 5/28/22.
//

import Foundation

struct MinNotionalFilter: Decodable {
    let filterType: SymbolFilter
    let minNotional: Decimal
    let applyToMarket: Bool
    let avgPriceMins: Int

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.filterType = try container.decode(SymbolFilter.self, forKey: .filterType)
        self.minNotional = try container.decimalFromString(codingKey: .minNotional)
        self.applyToMarket = try container.decode(Bool.self, forKey: .applyToMarket)
        self.avgPriceMins = try container.decode(Int.self, forKey: .avgPriceMins)
    }

    enum CodingKeys: String, CodingKey {
        case filterType = "filterType"
        case minNotional = "minNotional"
        case applyToMarket = "applyToMarket"
        case avgPriceMins = "avgPriceMins"
    }
}
