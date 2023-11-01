//
//  UserAccount.swift
//  CryptoBot
//
//  Created by Andre Muis on 4/25/22.
//

import Combine
import Foundation
import SwiftSMTP

class UserAccount: ObservableObject {
    private let dataLayer = DataLayer()

    private var assetExclusionList = ["AMP", "BUSD", "DAI", "KSHIB", "NANO", "REP", "TUSD", "USD", "USD4", "USDC", "USDT", "UST", "WBTC"]

    @Published var accountAssetList = [AccountAsset]()
    @Published var accountAssetListSorted = [AccountAsset]()

    @Published var balance = Decimal(0.0)
    @Published var quoteBalance = Decimal(0.0)
    @Published var portfolioBalance = Decimal(0.0)

    func downloadData() async throws {
        self.accountAssetList = []
        self.accountAssetListSorted = []

        self.balance = Decimal(0.0)
        self.quoteBalance = Decimal(0.0)
        self.portfolioBalance = Decimal(0.0)

        let accountBalanceList = try await self.dataLayer.getAccountBalanceList()
        try self.process(accountBalanceList: accountBalanceList)
    }

    private func process(accountBalanceList: [AccountBalance]) throws {
        try self.createAccountAssetList(accountBalanceList: accountBalanceList)
        try self.determineBalances(accountBalanceList: accountBalanceList)
    }

    private func createAccountAssetList(accountBalanceList: [AccountBalance]) throws {
        var list = [AccountAsset]()

        let accountBalanceListFiltered = accountBalanceList.filter({ !self.assetExclusionList.contains($0.symbol) })

        for balance in accountBalanceListFiltered {
            guard let price = PriceList.shared.price(marketPairSymbol: balance.marketPairSymbol) else {
                throw AppError.genericError(message: "could not find price for \(balance.marketPairSymbol)")
            }

            guard let exchangeSymbol = Exchange.shared.symbol(marketPairSymbol: balance.marketPairSymbol) else {
                throw AppError.genericError(message: "could not find exchange symbol for \(balance.marketPairSymbol)")
            }

            let accountAsset = AccountAsset(symbol: balance.symbol,
                                            free: balance.free,
                                            locked: balance.locked,
                                            price: price.amount,
                                            minSellQuoteQuantity: exchangeSymbol.minNotionalFilter.minNotional,
                                            quotePrecision: exchangeSymbol.quoteAssetPrecision)

            list.append(accountAsset)
        }

        self.accountAssetList = list
        self.accountAssetListSorted = list.sorted(by: { $0.sellQuoteQuantity > $1.sellQuoteQuantity })
    }

    private func determineBalances(accountBalanceList: [AccountBalance]) throws {
        guard let quoteAccountBalance = accountBalanceList.filter({ $0.symbol == Constants.quoteSymbol }).first else {
            throw AppError.genericError(message: "could not find \(Constants.quoteSymbol) asset in account balances")
        }

        self.quoteBalance = quoteAccountBalance.free + quoteAccountBalance.locked

        self.portfolioBalance = self.accountAssetList.reduce(0) { $0 + $1.balance }

        self.balance = self.portfolioBalance + self.quoteBalance
    }
}
