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
        }
    }

    private func run() {
        self.status = .running

        let currentDate = Date()

        self.lastRunDate = currentDate
        self.lastRunDateAsString = currentDate.formatted(date: .abbreviated, time: .standard)

        self.error = nil

        Task {
            do {
                try await self.downloadData()

                try await self.createSellOrders()
            } catch {
                self.error = error
                Logger.shared.add(entry: error.localizedDescription)
            }

            self.status = .idle

            DispatchQueue.main.asyncAfter(deadline: .now() + Constants.tradingEngineRunIntervalInSeconds) {
                self.run()
            }
        }
    }

    private func createSellOrders() async throws {
        let assetList = self.userAccount.assetList.filter({ $0.canSell })

        for asset in assetList {
            try await self.dataLayer.createSellOrder(tradingPairSymbol: asset.tradingPairSymbol,
                                                     quoteQuantity: asset.sellBalance,
                                                     quotePrecision: asset.quotePrecision)

            Logger.shared.add(entry: "Sold $\(asset.sellBalance) worth of \(asset.tradingPairSymbol)")
        }

        if assetList.count >= 1 {
            try await self.downloadData()
        }
    }

    private func downloadData() async throws {
        try await TradingPairList.shared.downloadData()
        try await PriceList.shared.downloadData()
        try await self.userAccount.downloadData()
    }
}
