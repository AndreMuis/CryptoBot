//
//  AccountAsset.swift
//  CryptoBot
//
//  Created by Andre Muis on 4/25/22.
//

import Foundation

struct AccountAsset: Hashable {
    let name: String
    var free: Decimal
    var locked: Decimal
    var price: Decimal
    var lastTrade: Trade?
    var shouldUpdateLastTrade: Bool

    var marketPairSymbol: String {
        return "\(self.name)\(Constants.quoteAssetSymbol)"
    }

    var freeAsString: String {
        return self.free.stringValue
    }

    var lockedAsString: String {
        return self.locked.stringValue
    }

    var quoteQuantity: Decimal? {
        return (self.free + self.locked) * price
    }

    var quoteQuantityAsString: String {
        return self.quoteQuantity?.currencyAsString ?? ""
    }

    var priceAsString: String {
        return price.stringValue
    }

    var lastTradePriceAsString: String {
        if let lastTradePrice = self.lastTrade?.price {
            return lastTradePrice.stringValue
        } else {
            return ""
        }
    }

    init(name: String, free: Decimal, locked: Decimal, price: Decimal) {
        self.name = name
        self.free = free
        self.locked = locked
        self.price = price
        self.lastTrade = nil
        self.shouldUpdateLastTrade = true
    }
}
