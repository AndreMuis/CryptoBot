//
//  LotSizeSymbolFilter.swift
//  Crypto Bot
//
//  Created by Andre Muis on 5/28/22.
//

import Foundation

struct LotSizeSymbolFilter: Decodable {
    let filterType: SymbolFilter
    let stepSize: Decimal

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.filterType = try container.decode(SymbolFilter.self, forKey: .filterType)
        self.stepSize = try container.decimalFromString(codingKey: .stepSize)
    }

    enum CodingKeys: String, CodingKey {
        case filterType = "filterType"
        case stepSize = "stepSize"
    }
}
