//
//  TradingViewModel.swift
//  Crypto Bot
//
//  Created by Andre Muis on 10/31/23.
//

import Foundation

class TradingViewModel: ObservableObject {
    let dataLayer = DataLayer()
    let userAccount: UserAccount

    private var accountAssetToBuy = [AccountAsset]()
    private var assetIndex = 0

    @Published var isAlertPresented = false
    @Published var alertMessage = ""

    init(userAccount: UserAccount) {
        self.userAccount = userAccount
    }

    func buyAssets() {
        self.accountAssetToBuy = self.userAccount.accountAssetListSorted.filter({ $0.balance < 1.0 })

        let asset = self.accountAssetToBuy[self.assetIndex]

        self.alertMessage = "Buy \(Constants.initialBalance.currencyAsString) of \(asset.symbol)"
        self.isAlertPresented = true
    }

    func buyAsset() {

        Task {
            var asset = self.accountAssetToBuy[self.assetIndex]

            _ = try await self.dataLayer.createBuyOrder(marketPairSymbol: asset.marketPairSymbol,
                                                        quoteQuantity: Constants.initialBalance,
                                                        quotePrecision: asset.quotePrecision)

            self.assetIndex += 1
            asset = self.accountAssetToBuy[self.assetIndex]

            self.alertMessage = "Buy \(Constants.initialBalance.currencyAsString) of \(asset.symbol)"
            self.isAlertPresented = true
        }
    }
}
