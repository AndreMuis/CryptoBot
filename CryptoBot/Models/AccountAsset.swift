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
    var price: Decimal
    var lastTrade: Trade?
    var shouldUpdateLastTrade: Bool

    var marketPairSymbol: String {
        return "\(self.name)\(Constants.quoteAssetSymbol)"
    }

    var freeAsString: String {
        return self.free.stringValue
    }

    var quantity: Decimal? {
        return self.free * price
    }

    var quantityAsString: String {
        if let quantity = self.quantity {
            return quantity.currencyAsString
        } else {
            return ""
        }
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

    init(name: String, free: Decimal, price: Decimal) {
        self.name = name
        self.free = free
        self.price = price
        self.lastTrade = nil
        self.shouldUpdateLastTrade = true
    }
}
