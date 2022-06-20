//
//  Constants.swift
//  CryptoBot
//
//  Created by Andre Muis on 4/23/22.
//

import CoreGraphics
import Foundation

struct Constants {
    static let windowSize = CGSize(width: 800.0, height: 600.0)

    static let binanceUSAPIKeyKey = "binanceUSAPIKey"
    static let binanceUSAPISecretKeyKey = "binanceUSSecretKey"

    static let binanceUSAPIKeyHeaderKey = "X-MBX-APIKEY"

    static let marketPairSymbolQueryItemName = "symbol"
    static let intervalQueryItemName = "interval"
    static let limitQueryItemName = "limit"
    static let sideQueryItemName = "side"
    static let typeQueryItemName = "type"
    static let quantityQueryItemName = "quantity"
    static let quoteOrderQuantityQueryItemName = "quoteOrderQty"
    static let limitPriceQueryItemName = "price"
    static let stopPriceQueryItemName = "stopPrice"
    static let stopLimitPriceQueryItemName = "stopLimitPrice"
    static let stopLimitTimeInForceQueryItemName = "stopLimitTimeInForce"
    static let timestampQueryItemName = "timestamp"
    static let signatureQueryItemName = "signature"

    static let filterTypeKey = "filterType"
    static let tickSizeKey = "tickSize"
    static let lotSizeKey = "lotSize"

    static var smtpServerHostnameKey = "SMTPServerHostname"
    static var smtpServerEmailKey = "SMTPServerEmail"
    static var smtpServerPasswordKey = "SMTPServerPassword"

    static var fromEmail = "no-reply@company.com"

    static let tradingEngineRunIntervalInSeconds = 5 * 60

    static let quoteAssetSymbol = "USD"

    static let purchaseAmount: Decimal = 100
    
    static let priceSellMaxMultiplier: Decimal = 1.01
    static let priceSellMinMultiplier: Decimal = 0.99

    static let klineListLimit = 100

    static let rsiPeriod = 14
    static let rsiSellTheshold = 30.0

    static let mfiPeriod = 14
    static let mfiSellTheshold = 20.0

    static let serverRequestDelayInterval = 0.2
}
