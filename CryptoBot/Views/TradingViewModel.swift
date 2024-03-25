//
//  TradingViewModel.swift
//  Crypto Bot
//
//  Created by Andre Muis on 10/31/23.
//

import Foundation

class TradingViewModel: ObservableObject {
    private let dataLayer = DataLayer()

    private var userAccount: UserAccount
    
    @Published private(set) var error: Error?

    init(userAccount: UserAccount) {
        self.userAccount = userAccount
    }

    func buy(accountAsset: AccountAsset) {
        self.error = nil

        Task {
            do {
                try await self.dataLayer.createBuyOrder(tradingPairSymbol: accountAsset.tradingPairSymbol,
                                                        quoteQuantity: accountAsset.buyBalance,
                                                        quotePrecision: accountAsset.quotePrecision)

                try await self.refreshUserAccount()
            } catch {
                self.error = error
                Logger.shared.add(entry: error.localizedDescription)
            }
        }
    }

    func sell(accountAsset: AccountAsset) {
        self.error = nil

        Task {
            do {
                _ = try await self.dataLayer.createSellOrder(tradingPairSymbol: accountAsset.tradingPairSymbol,
                                                             quoteQuantity: accountAsset.sellBalance,
                                                             quotePrecision: accountAsset.quotePrecision)

                try await self.refreshUserAccount()
            } catch {
                self.error = error
                Logger.shared.add(entry: error.localizedDescription)
            }
        }
    }

    private func refreshUserAccount() async throws {
        try await TradingPairList.shared.downloadData()
        try await PriceList.shared.downloadData()
        try await self.userAccount.downloadData()
    }
}
