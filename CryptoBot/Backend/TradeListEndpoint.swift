//
//  TradeEndpoint.swift
//  CryptoBot
//
//  Created by Andre Muis on 4/28/22.
//

import Foundation

struct TradeListEndpoint: Endpoint {
    let url: URL
    let httpMethod: String
    let httpHeaderFieldDictionary: [String : String]?

    private let shell = Shell()

    init(tradingPairSymbol: String) throws {
        guard let binanceUSAPIKey = AppDefaults.shared.binanceUSAPIKey else {
            throw AppError.genericError(message: "could not retrieve Binance US API key from app defaults")
        }

        self.httpMethod = "GET"
        self.httpHeaderFieldDictionary = [Constants.binanceUSAPIKeyHeaderKey: binanceUSAPIKey]

        let timestamp = Date.timestamp

        var url = try AppConfiguration.getURL(for: .binanceUSTradesURLKey)

        var queryItems = [
            URLQueryItem(name: Constants.marketPairSymbolQueryItemName, value: tradingPairSymbol),
            URLQueryItem(name: Constants.timestampQueryItemName, value: String(timestamp))
        ]

        url = try URL.updateQuery(url: url, queryItems: queryItems)

        guard let query = url.query else {
            throw AppError.genericError(message: "unable to parse query string from URL")
        }

        let signature = try self.shell.getSignature(query: query)
        queryItems.append(URLQueryItem(name: Constants.signatureQueryItemName, value: signature))

        self.url = try URL.updateQuery(url: url, queryItems: queryItems)
    }
}
