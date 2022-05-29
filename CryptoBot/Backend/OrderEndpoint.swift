//
//  OrderEndpoint.swift
//  CryptoBot
//
//  Created by Andre Muis on 4/28/22.
//

import Foundation

struct OrderEndpoint: Endpoint {
    let url: URL
    let httpMethod: String
    let httpHeaderFieldDictionary: [String : String]?

    private let shell = Shell()

    init(marketPairSymbol: String,
         type: OrderType,
         quoteOrderQuantity: Decimal) throws {
        guard let binanceUSAPIKey = AppDefaults.shared.binanceUSAPIKey else {
            throw AppError.genericError(message: "could not retrieve Binance US API key from app defaults")
        }

        self.httpMethod = "POST"
        self.httpHeaderFieldDictionary = [Constants.binanceUSAPIKeyHeaderKey: binanceUSAPIKey]

        let timestamp = Date.timestamp

        var url = try AppConfiguration.getURL(for: .binanceUSOrderURLKey)

        var queryItems = [
            URLQueryItem(name: Constants.marketPairSymbolQueryItemName, value: marketPairSymbol),
            URLQueryItem(name: Constants.sideQueryItemName, value: OrderSide.buy.rawValue),
            URLQueryItem(name: Constants.typeQueryItemName, value: type.rawValue),
            URLQueryItem(name: Constants.quoteOrderQuantityQueryItemName, value: quoteOrderQuantity.stringValue),
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
