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
    let httpHeaderFields: [String : String]?
    let httpPOSTFields: [String : String]?

    private let shell = Shell()

    init(tradingPairSymbol: String, side: OrderSide, quoteQuantity: Decimal, quotePrecision: Decimal) throws {
        let timestampAsString = Date.timestampAsString
        let requestTimeoutAsString = String(Constants.requestTimeoutInMilliseconds)

        guard let byBitAPIKey = AppDefaults.shared.byBitAPIKey else {
            throw AppError.genericError(message: "could not retrieve ByBit API key from app defaults")
        }

        let quoteQuantityAsString = quoteQuantity.getStringValue(maximumFractionDigits: quotePrecision.significantFractionDigits)

        let postFields = [
            Constants.APIQueryItemNames.productCategory: ProductCategory.spot.rawValue,
            Constants.APIQueryItemNames.tradingPairSymbol: tradingPairSymbol,
            Constants.APIQueryItemNames.orderSide: side.rawValue,
            Constants.APIQueryItemNames.orderType: OrderType.market.rawValue,
            Constants.APIQueryItemNames.quantity: quoteQuantityAsString,
            Constants.APIQueryItemNames.marketUnit: MarketUnit.quoteCoin.rawValue
        ]

        let httpPOSTData = try JSONSerialization.data(withJSONObject: postFields)

        guard let jsonString = String(data: httpPOSTData, encoding: .utf8) else {
            throw AppError.genericError(message: "unable to convert post fields as JSON data to String")
        }

        let text = "\(timestampAsString)\(byBitAPIKey)\(requestTimeoutAsString)\(jsonString)"
        let signature = try self.shell.getSignature(text: text)

        self.url = try AppConfiguration.getURL(for: .byBitOrderURLKey)
        self.httpMethod = "POST"

        self.httpHeaderFields = [
            Constants.APIHeaderKeys.timestamp: timestampAsString,
            Constants.APIHeaderKeys.byBitKey: byBitAPIKey,
            Constants.APIHeaderKeys.receiveWindow: String(Constants.requestTimeoutInMilliseconds),
            Constants.APIHeaderKeys.signature: signature]

        self.httpPOSTFields = postFields
    }
}
