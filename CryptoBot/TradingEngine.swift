//
//  TradingEngine.swift
//  CryptoBot
//
//  Created by Andre Muis on 4/24/22.
//

import Combine
import Foundation
import SwiftSMTP

class TradingEngine: ObservableObject {
    private let dataLayer = DataLayer()
    private let smtpClient = SMTPClient()

    private let userAccount: UserAccount

    @Published private(set) var lastRunDate: Date?
    @Published private(set) var lastRunDateAsString = ""
    @Published private(set) var status: TradingEngineStatus = .notStarted
    @Published private(set) var error: Error?

    init(userAccount: UserAccount) {
        self.userAccount = userAccount
    }

    func start() {
        if case .notStarted = self.status {
            self.run()

            Timer.scheduledTimer(withTimeInterval: Constants.tradingEngineRunIntervalInSeconds,
                                 repeats: true) { timer in
                if case .idle = self.status  {
                    self.run()
                }
            }
        }
    }

    private func run() {
        self.status = .running

        let currentDate = Date()

        self.lastRunDate = currentDate
        self.lastRunDateAsString = currentDate.formatted(date: .abbreviated, time: .shortened)

        self.error = nil

        Task {
            do {
                try await Exchange.shared.downloadData()
                try await PriceList.shared.downloadData()
                try await self.userAccount.downloadData()
                try await self.createBuyOrders()
            } catch {
                self.error = error
                Logger.shared.add(entry: error.localizedDescription)
            }

            self.status = .idle
        }
    }

    private func createBuyOrders() async throws {
        for asset in self.userAccount.accountAssetList.filter({ $0.canSell }) {
            let _ = try await self.dataLayer.createSellOrder(marketPairSymbol: asset.marketPairSymbol,
                                                             quoteQuantity: asset.sellQuoteQuantity,
                                                             quotePrecision: asset.quotePrecision)

            try await self.sendEmail(accountAsset: asset)
        }
    }

    private func sendEmail(accountAsset: AccountAsset) async throws {
        var subject: String
        var text: String

        let profit = accountAsset.sellQuoteQuantity.currencyAsString

        subject = "Sold \(profit) of \(accountAsset.symbol)"

        text = """
        \(accountAsset.marketPairSymbol)\n
        Balance before sale: \(accountAsset.balanceAsString)
        Sold: \(profit)
        """

        Logger.shared.add(entry: "\(subject): \(text)")

        try await self.smtpClient.sendEmail(subject: subject, text: text)
    }
}
