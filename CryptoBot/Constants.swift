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
        static let receiveWindow = "X-BAPI-RECV-WINDOW"
        static let signature = "X-BAPI-SIGN"
    }

    struct APIQueryItemNames {
        static let accountType = "accountType"
        static let productCategory = "category"
        static let tradingPairSymbol = "symbol"
        static let orderType = "orderType"
        static let orderSide = "side"
        static let quantity = "qty"
        static let marketUnit = "marketUnit"
    }

    static let responseCodeOK = 0
    static let requestTimeoutInMilliseconds = 5000

    static let fromEmail = "no-reply@company.com"

    static let tradingEngineRunIntervalInSeconds: TimeInterval = 5.0 * 60.0

    static let quoteSymbol = "USDT"
    static let initialBalance = Decimal(50.0)
}


