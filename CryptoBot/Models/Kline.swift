//
//  Kline.swift
//  CryptoBot
//
//  Created by Andre Muis on 4/27/22.
//

import Foundation

struct Kline {
    let marketPairSymbol: String
    let interval: KlineInterval
    let open: Decimal
    let close: Decimal
    let low: Decimal
    let high: Decimal
    let volume: Decimal
    let openDate: Date
    let closeDate: Date

    init(marketPairSymbol: String, interval: KlineInterval, values: [Any]) throws {
        self.marketPairSymbol = marketPairSymbol
        self.interval = interval

        if let valueAsString = values[1] as? String,
           let valueAsDecimal = Decimal(string: valueAsString) {
            self.open = valueAsDecimal
        } else {
            throw AppError.genericError(message: "could not convert Any to Decimal")
        }

        if let valueAsString = values[4] as? String,
           let valueAsDecimal = Decimal(string: valueAsString) {
            self.close = valueAsDecimal
        } else {
            throw AppError.genericError(message: "could not convert Any to Decimal")
        }

        if let valueAsString = values[3] as? String,
           let valueAsDecimal = Decimal(string: valueAsString) {
            self.low = valueAsDecimal
        } else {
            throw AppError.genericError(message: "could not convert Any to Decimal")
        }

        if let valueAsString = values[2] as? String,
           let valueAsDecimal = Decimal(string: valueAsString) {
            self.high = valueAsDecimal
        } else {
            throw AppError.genericError(message: "could not convert Any to Decimal")
        }

        if let valueAsString = values[5] as? String,
           let valueAsDecimal = Decimal(string: valueAsString) {
            self.volume = valueAsDecimal
        } else {
            throw AppError.genericError(message: "could not convert Any to Decimal")
        }

        if let valueAsInt = values[0] as? Int {
            self.openDate = Date(timeIntervalSince1970: TimeInterval(valueAsInt))
        } else {
            throw AppError.genericError(message: "could not convert Any to Int")
        }

        if let valueAsInt = values[6] as? Int {
            self.closeDate = Date(timeIntervalSince1970: TimeInterval(valueAsInt))
        } else {
            throw AppError.genericError(message: "could not convert Any to Int")
        }
    }
}
