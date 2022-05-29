//
//  TradingIndicators.swift
//  Crypto Bot
//
//  Created by Andre Muis on 5/1/22.
//

import Foundation

import tulipindicators

struct TradingIndicators {
    static func rsi(klineList: [Kline], period: Int) -> Double {
        let closeValues = klineList.map { $0.close.doubleValue }

        let rsiValues = tulipindicators.rsi(closeValues, period: period).1
        let rsi = rsiValues[rsiValues.count - 2]

        return rsi
    }

    static func mfi(klineList: [Kline], period: Int) -> Double {
        let quoteList = klineList.map { Quote(kline: $0) }

        let mfiValues = tulipindicators.mfi(quoteList, period: period).1
        let mfi = mfiValues[mfiValues.count - 2]

        return mfi
    }
}
