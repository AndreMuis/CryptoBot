//
//  Quote.swift
//  Crypto Bot
//
//  Created by Andre Muis on 5/1/22.
//

import Foundation

import tulipindicators

struct Quote: Quotable {
    private let kline: Kline

    var open: Double {
        kline.open.doubleValue
    }

    var close: Double {
        kline.close.doubleValue
    }

    var low: Double {
        kline.low.doubleValue
    }

    var high: Double {
        kline.high.doubleValue
    }

    var volume: Int {
        kline.volume.intValue
    }

    init(kline: Kline) {
        self.kline = kline
    }
}
