//
//  TradingPairList.swift
//  Crypto Bot
//
//  Created by Andre Muis on 10/30/23.
//

import Foundation

class TradingPairList {
    static let shared = TradingPairList()

    private let dataLayer = DataLayer()
    var list = [TradingPair]()

    func downloadData() async throws {
        do {
            self.list = try await self.dataLayer.getTradingPairList()
        }
    }

    func tradingPair(symbol: String) -> TradingPair? {
        return self.list.filter({ $0.symbol == symbol }).first
    }
}
