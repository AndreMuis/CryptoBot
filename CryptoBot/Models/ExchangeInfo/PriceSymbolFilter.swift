//
//  PriceSymbolFilter.swift
//  Crypto Bot
//
//  Created by Andre Muis on 5/28/22.
//

import Foundation

struct PriceSymbolFilter: Decodable {
    let filterType: SymbolFilter
    let tickSize: Decimal

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.filterType = try container.decode(SymbolFilter.self, forKey: .filterType)
        self.tickSize = try container.decimalFromString(codingKey: .tickSize)
    }

    enum CodingKeys: String, CodingKey {
        case filterType = "filterType"
        case tickSize = "tickSize"
    }
}
