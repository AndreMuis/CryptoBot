//
//  Constants.swift
//  CryptoBot
//
//  Created by Andre Muis on 4/23/22.
//

import CoreGraphics
import Foundation

struct Constants {
    static let binanceUSAPIKeyKey = "binanceUSAPIKey"
    static let binanceUSAPISecretKeyKey = "binanceUSSecretKey"

    static let binanceUSAPIKeyHeaderKey = "X-MBX-APIKEY"

    static let marketPairSymbolQueryItemName = "symbol"
    static let sideQueryItemName = "side"
    static let typeQueryItemName = "type"
    static let quoteOrderQuantityQueryItemName = "quoteOrderQty"
    static let timestampQueryItemName = "timestamp"
    static let signatureQueryItemName = "signature"

    static var smtpServerHostnameKey = "SMTPServerHostname"
    static var smtpServerEmailKey = "SMTPServerEmail"
    static var smtpServerPasswordKey = "SMTPServerPassword"

    static var fromEmail = "no-reply@company.com"

    static let tradingEngineRunIntervalInSeconds: TimeInterval = 1.0 * 60.0

    static let quoteSymbol = "USDT"
    static let initialBalance = Decimal(100.0)
}
