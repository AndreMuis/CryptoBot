//
//  AccountAsset.swift
//  CryptoBot
//
//  Created by Andre Muis on 4/25/22.
//

import Foundation

struct AccountAsset: Hashable {
    let symbol: String
    private let free: Decimal
    private let locked: Decimal
    private let price: Decimal
    private let minSellQuoteQuantity: Decimal
    let quotePrecision: Int

    var marketPairSymbol: String {
        return "\(self.symbol)\(Constants.quoteSymbol)"
    }

    var freeAsString: String {
        return self.free.stringValue
    }

    var lockedAsString: String {
        return self.locked.stringValue
    }

    var priceAsString: String {
        return price.stringValue
    }

    var balance: Decimal {
        return (self.free + self.locked) * price
    }

    var balanceAsString: String {
        return self.balance.currencyAsString
    }

    private var sellBalance: Decimal {
        return Constants.initialBalance + self.minSellQuoteQuantity
    }

    var sellBalanceAsString: String {
        return self.sellBalance.currencyAsString
    }

    var sellQuoteQuantity: Decimal {
        return self.balance - Constants.initialBalance
    }

    var canSell: Bool {
        return self.balance > self.sellBalance
    }

    init(symbol: String, free: Decimal, locked: Decimal, price: Decimal, minSellQuoteQuantity: Decimal, quotePrecision: Int) {
        self.symbol = symbol
        self.free = free
        self.locked = locked
        self.price = price
        self.minSellQuoteQuantity = minSellQuoteQuantity
        self.quotePrecision = quotePrecision
    }
}
