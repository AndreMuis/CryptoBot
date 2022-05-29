//
//  DashboardViewModel.swift
//  CryptoBot
//
//  Created by Andre Muis on 4/22/22.
//

import Cocoa
import Combine
import Foundation
import SwiftUI

class DashboardViewModel: ObservableObject {
    @ObservedObject private var tradingEngine = TradingEngine()

    @Published var balance = ""
    @Published var quoteBalance = ""
    @Published var portfolioBalance = ""
    @Published var accountAssetList = [AccountAsset]()
    @Published var tradingEngineStatus = TradingEngineStatus.notStarted.rawValue
    @Published var lastRunDateAsString = ""
    @Published var errorMessage = ""

    private var subscribers = Set<AnyCancellable>()

    var daraLayer = DataLayer()
    var smtpClient = SMTPClient()

    func startTradingEngine() {
        self.tradingEngine.start()

        Publishers.Zip(
            self.tradingEngine.$quoteBalance.compactMap({ $0 }),
            self.tradingEngine.$portfolioBalance.compactMap({ $0 }))
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { quoteBalance, portfolioBalance in
                self.balance = (quoteBalance + portfolioBalance).currencyAsString
                self.quoteBalance = quoteBalance.currencyAsString
                self.portfolioBalance = portfolioBalance.currencyAsString
            })
            .store(in: &self.subscribers)

        self.tradingEngine.$accountAssetList
            .receive(on: DispatchQueue.main)
            .compactMap({ $0 })
            .sink(receiveValue: { list in
                let list = list.sorted(by: { $0.quantity ?? 0.0 > $1.quantity ?? 0.0 })
                self.accountAssetList = list
            })
            .store(in: &self.subscribers)

        self.tradingEngine.$status
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { status in
                self.tradingEngineStatus = status.rawValue
            })
            .store(in: &self.subscribers)

        self.tradingEngine.$lastRunDate
            .receive(on: DispatchQueue.main)
            .compactMap { $0?.formatted(date: .abbreviated, time: .shortened) }
            .sink(receiveValue: { date in
                self.lastRunDateAsString = date
            })
            .store(in: &self.subscribers)

        self.tradingEngine.$error
            .receive(on: DispatchQueue.main)
            .map { $0?.localizedDescription ?? "" }
            .sink(receiveValue: { localizedDescription in
                if !localizedDescription.isEmpty {
                    Logger.shared.add(entry: localizedDescription)
                }

                self.errorMessage = localizedDescription
            })
            .store(in: &self.subscribers)
    }
}
