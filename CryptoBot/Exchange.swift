//
//  Exchange.swift
//  Crypto Bot
//
//  Created by Andre Muis on 10/30/23.
//

import Foundation

class Exchange {
    static let shared = Exchange()

    private let dataLayer = DataLayer()
    private var info = ExchangeInfo(symbols: [])

    func downloadData() async throws {
        do {
            self.info = try await self.dataLayer.getExchangeInfo()
        }
    }

    func symbol(marketPairSymbol: String) -> ExchangeInfoSymbol? {
        return self.info.symbols.filter({ $0.marketPairSymbol == marketPairSymbol }).first
    }
}
