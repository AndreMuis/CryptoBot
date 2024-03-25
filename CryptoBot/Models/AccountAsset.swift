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
    let canTrade: Bool
    let minTradeQuoteQuantity: Decimal
    let quotePrecision: Decimal

    var tradingPairSymbol: String {
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

    var isProfitable: Bool {
        return self.balance > Constants.initialBalance 
    }

    var buyBalance: Decimal {
        return Constants.initialBalance - self.balance
    }

    var buyBalanceAsString: String {
        return self.buyBalance.currencyAsString
    }

    var canBuy: Bool {
        return self.canTrade && (self.buyBalance > self.minTradeQuoteQuantity)
    }

    var sellBalance: Decimal {
        return self.balance - Constants.initialBalance
    }

    var sellBalanceAsString: String {
        return self.sellBalance.currencyAsString
    }

    var canSell: Bool {
        return self.canTrade && (self.sellBalance > self.minTradeQuoteQuantity)
    }

    init(symbol: String, 
         free: Decimal,
         locked: Decimal,
         price: Decimal,
         canTrade: Bool,
         minTradeQuoteQuantity: Decimal,
         quotePrecision: Decimal) {
        self.symbol = symbol
        self.free = free
        self.locked = locked
        self.price = price
        self.canTrade = canTrade
        self.minTradeQuoteQuantity = minTradeQuoteQuantity
        self.quotePrecision = quotePrecision
    }
}
