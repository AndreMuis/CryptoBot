//
//  OCOOrderEndpoint.swift
//  Crypto Bot
//
//  Created by Andre Muis on 5/21/22.
//

import Foundation

struct OCOOrderEndpoint: Endpoint {
    let url: URL
    let httpMethod: String
    let httpHeaderFieldDictionary: [String : String]?

    private let shell = Shell()

    init(marketPairSymbol: String,
         quantity: Decimal,
         limitPrice: Decimal,
         stopPrice: Decimal,
         stopLimitPrice: Decimal,
         stopLimitTimeInForce: TimeInForce) throws {
        guard let binanceUSAPIKey = AppDefaults.shared.binanceUSAPIKey else {
            throw AppError.genericError(message: "could not retrieve Binance US API key from app defaults")
        }

        self.httpMethod = "POST"
        self.httpHeaderFieldDictionary = [Constants.binanceUSAPIKeyHeaderKey: binanceUSAPIKey]

        let timestamp = Date.timestamp

        var url = try AppConfiguration.getURL(for: .binanceUSOCOOrderURLKey)

        var queryItems = [
            URLQueryItem(name: Constants.marketPairSymbolQueryItemName, value: marketPairSymbol),
            URLQueryItem(name: Constants.sideQueryItemName, value: OrderSide.sell.rawValue),
            URLQueryItem(name: Constants.quantityQueryItemName, value: quantity.stringValue),
            URLQueryItem(name: Constants.limitPriceQueryItemName, value: limitPrice.stringValue),
            URLQueryItem(name: Constants.stopPriceQueryItemName, value: stopPrice.stringValue),
            URLQueryItem(name: Constants.stopLimitPriceQueryItemName, value: stopLimitPrice.stringValue),
            URLQueryItem(name: Constants.stopLimitTimeInForceQueryItemName, value: stopLimitTimeInForce.rawValue),
            URLQueryItem(name: Constants.timestampQueryItemName, value: String(timestamp)),
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
