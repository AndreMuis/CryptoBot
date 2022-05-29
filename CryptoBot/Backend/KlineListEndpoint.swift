//
//  KlineListEndpoint.swift
//  CryptoBot
//
//  Created by Andre Muis on 4/27/22.
//

import Foundation

struct KlineListEndpoint: Endpoint {
    let url: URL
    let httpMethod: String
    let httpHeaderFieldDictionary: [String : String]?

    init(marketPairSymbol: String, interval: KlineInterval, limit: Int) throws {
        self.httpMethod = "GET"
        self.httpHeaderFieldDictionary = nil

        var url: URL

        url = try AppConfiguration.getURL(for: .binanceUSKlinesURLKey)

        let queryItems = [
            URLQueryItem(name: Constants.marketPairSymbolQueryItemName, value: marketPairSymbol),
            URLQueryItem(name: Constants.intervalQueryItemName, value: interval.rawValue),
            URLQueryItem(name: Constants.limitQueryItemName, value: String(limit))
        ]

        self.url = try URL.updateQuery(url: url, queryItems: queryItems)
    }
}
