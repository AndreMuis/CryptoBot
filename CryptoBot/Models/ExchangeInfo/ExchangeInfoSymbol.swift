//
//  ExchangeInfoSymbol.swift
//  Crypto Bot
//
//  Created by Andre Muis on 5/28/22.
//

import Foundation

struct ExchangeInfoSymbol: Decodable {
    let marketPairSymbol: String
    let baseAssetSymbol: String
    let quoteAssetSymbol: String
    let quotePrecision: Int
    let quoteAssetPrecision: Int
    let priceTickSize: Decimal
    let lotStepSize: Decimal

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.marketPairSymbol = try container.decode(String.self, forKey: .marketPairSymbol)
        self.baseAssetSymbol = try container.decode(String.self, forKey: .baseAssetSymbol)
        self.quoteAssetSymbol = try container.decode(String.self, forKey: .quoteAssetSymbol)
        self.quotePrecision = try container.decode(Int.self, forKey: .quotePrecision)
        self.quoteAssetPrecision = try container.decode(Int.self, forKey: .quoteAssetPrecision)

        var filtersContainer = try container.nestedUnkeyedContainer(forKey: .filters)

        let priceSymbolFilter = try filtersContainer.decode(PriceSymbolFilter.self)
        self.priceTickSize = priceSymbolFilter.tickSize

        _ = try filtersContainer.decode(DummyDecodable.self)

        let lotSizeSymbolFilter = try filtersContainer.decode(LotSizeSymbolFilter.self)
        self.lotStepSize = lotSizeSymbolFilter.stepSize
    }

    enum CodingKeys: String, CodingKey {
        case marketPairSymbol = "symbol"
        case baseAssetSymbol = "baseAsset"
        case quoteAssetSymbol = "quoteAsset"
        case quotePrecision = "quotePrecision"
        case quoteAssetPrecision = "quoteAssetPrecision"
        case filters = "filters"
    }
}
