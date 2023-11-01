//
//  PriceList.swift
//  Crypto Bot
//
//  Created by Andre Muis on 10/31/23.
//

import Foundation

class PriceList {
    static let shared = PriceList()

    private let dataLayer = DataLayer()
    private var list = [Price]()

    func downloadData() async throws {
        do {
            self.list = try await self.dataLayer.getPriceList()
        }
    }

    func price(marketPairSymbol: String) -> Price? {
        return self.list.filter({ $0.marketPairSymbol == marketPairSymbol }).first
    }
}
