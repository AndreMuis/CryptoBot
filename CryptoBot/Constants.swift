//
//  Constants.swift
//  CryptoBot
//
//  Created by Andre Muis on 4/23/22.
//

import CoreGraphics
import Foundation

struct Constants {
    struct AppDefaultKeys {
        static let byBitAPIKey = "byBitAPIKey"
        static let byBitAPISecret = "byBitAPISecret"

        static var smtpServerHostname = "SMTPServerHostname"
        static var smtpServerEmail = "SMTPServerEmail"
        static var smtpServerPassword = "SMTPServerPassword"
    }

    struct APIHeaderKeys {
        static let byBitKey = "X-BAPI-API-KEY"
        static let timestamp = "X-BAPI-TIMESTAMP"
        static let signature = "X-BAPI-SIGN"
    }

    struct APIQueryItemNames {
        static let tradingPairSymbol = "symbol"
        static let orderSide = "side"
        static let orderType = "orderType"
        static let quantity = "qty"
        static let timestamp = "timestamp"
        static let signature = "signature"
        static let productCategory = "category"
        static let marketUnit = "marketUnit"
        static let accountType = "accountType"
    }

    static let responseCodeOK = 0

    static let fromEmail = "no-reply@company.com"

    static let tradingEngineRunIntervalInSeconds: TimeInterval = 5.0 * 60.0

    static let quoteSymbol = "USDT"
    static let initialBalance = Decimal(100.0)


}


