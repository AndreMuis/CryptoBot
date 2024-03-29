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

    private var assetExclusionList = [Constants.quoteSymbol, "TOMS", "JEFF", "KUB", "TRC", "PURSE", "BTC3S", "BTC3L", "ETH3S", "ETH3L", "XRP3S", "XRP3L", "DOT3S", "DOT3L", "AVAX2S", "AVAX2L", "ADA2S", "ADA2L", "LTC2S", "LTC2L", "SAND2S", "SAND2L", "MATIC2S", "MATIC2L", "ETC2S", "ETC2L", "APE2S", "APE2L", "GMT2S", "GMT2L", "LINK2L", "LINK2S", "FTM2L", "FTM2S", "DOGE2S", "DOGE2L", "ATOM2S", "ATOM2L", "EOS2S", "EOS2L"]

    @Published var assetList = [AccountAsset]()
    @Published var assetCount = 0
    @Published var assetListSortedByBalance = [AccountAsset]()

    @Published var balance = Decimal(0.0)
    @Published var quoteBalance = Decimal(0.0)
    @Published var portfolioBalance = Decimal(0.0)

    func downloadData() async throws {
        let accountBalance = try await self.dataLayer.getAccountBalance()

        try self.createAccountAssetList(accountBalance: accountBalance)
        try self.determineBalances(accountBalance: accountBalance)
    }

    private func createAccountAssetList(accountBalance: AccountBalance) throws {
        var list = [AccountAsset]()
        
        let pairs = TradingPairList.shared.list.filter({
            $0.quoteCoin == Constants.quoteSymbol && 
            $0.canTrade &&
            !self.assetExclusionList.contains($0.baseCoin) })
        
        for pair in pairs {
            guard let price = PriceList.shared.price(tradingPairSymbol: pair.symbol) else {
                throw AppError.genericError(message: "Could not find price in price list for \(pair.symbol)")
            }

            let coin = accountBalance.coin(symbol: pair.baseCoin)

            let accountAsset = AccountAsset(symbol: pair.baseCoin,
                                            free: coin?.free ?? 0.0,
                                            locked: coin?.locked ?? 0.0,
                                            price: price.lastPrice,
                                            canTrade: pair.canTrade,
                                            minTradeQuoteQuantity: pair.lotSizeFilter.minOrderAmount,
                                            quotePrecision: pair.lotSizeFilter.quotePrecision)

            list.append(accountAsset)
        }

        self.assetList = list
        self.assetCount = list.count
        self.assetListSortedByBalance = list.sorted(by: { $0.balance > $1.balance })
    }

    private func determineBalances(accountBalance: AccountBalance) throws {
        guard let quoteAccountBalance = accountBalance.coinList.filter({ $0.symbol == Constants.quoteSymbol }).first else {
            throw AppError.genericError(message: "could not find \(Constants.quoteSymbol) asset in account balances")
        }

        self.quoteBalance = quoteAccountBalance.free + quoteAccountBalance.locked

        self.portfolioBalance = self.assetList.reduce(0) { $0 + $1.balance }

        self.balance = self.portfolioBalance + self.quoteBalance
    }
}
