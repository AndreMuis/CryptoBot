//
//  UserAccount.swift
//  CryptoBot
//
//  Created by Andre Muis on 4/25/22.
//

import Combine
import Foundation
import SwiftSMTP

class UserAccount {
    private let dataLayer = DataLayer()
    private let smtpClient = SMTPClient()

    var exchangeInfo = ExchangeInfo(symbols: [])
    var priceList = [Price]()
    var priceChangeStatisticsList = [PriceChangeStatistics]()

    var quoteBalance: Decimal?
    var accountAssetList = [AccountAsset]()

    var lastTradesUpdated = false

    var portfolioBalance: Decimal {
        var balance: Decimal = 0.0

        for asset in self.accountAssetList {
            balance += asset.quoteQuantity ?? 0.0
        }

        return balance
    }

    private var tradingExclusionAssetList = ["BNB", "HNT"]

    private var subscribers = Set<AnyCancellable>()

    func downloadData() -> Future<Void, Error> {
        let future = Future<Void, Error> { promise in
            do {
                let exchangeInfoPublisher = try self.dataLayer.getExchangeInfo()
                let accountBalanceListPublisher = try self.dataLayer.getAccountBalanceList()
                let priceListPublisher = try self.dataLayer.getPriceList()
                let priceChangeStatisticsListPublisher = try self.dataLayer.getPriceChangeStatisticsList()

                Publishers.Zip4(exchangeInfoPublisher,
                                accountBalanceListPublisher,
                                priceListPublisher,
                                priceChangeStatisticsListPublisher)
                    .sink { completion in
                        if case let .failure(error) = completion {
                            promise(.failure(error))
                        }
                    } receiveValue: { exchangeInfo, accountBalanceList, priceList, priceChangeStatisticsList in
                        self.exchangeInfo = exchangeInfo
                        self.priceList = priceList
                        self.priceChangeStatisticsList = priceChangeStatisticsList

                        self.processData(exchangeInfo: exchangeInfo,
                                         accountBalanceList: accountBalanceList,
                                         priceList: priceList,
                                         promise: promise)

                        self.updateLastTrades()
                            .sink { completion in
                                switch completion {
                                case .finished:
                                    self.lastTradesUpdated = true
                                    promise(.success(()))

                                case .failure(let error):
                                    promise(.failure(error))
                                }
                            } receiveValue: { _ in }
                            .store(in: &self.subscribers)
                    }
                    .store(in: &self.subscribers)
            } catch {
                promise(.failure(error))
            }
        }

        return future
    }

    private func processData(exchangeInfo: ExchangeInfo,
                             accountBalanceList: [AccountBalance],
                             priceList: [Price],
                             promise: Future<Void, Error>.Promise) {
        do {
            try self.determineBalance(accountBalanceList: accountBalanceList)

            try self.updateAccountAssetList(exchangeInfo: exchangeInfo,
                                            accountBalanceList: accountBalanceList,
                                            priceList: priceList)
        } catch {
            promise(.failure(error))
        }
    }

    private func determineBalance(accountBalanceList: [AccountBalance]) throws {
        do {
            if let balance = accountBalanceList.filter({ $0.asset == Constants.quoteAssetSymbol }).first {
                self.quoteBalance = balance.free
            } else {
                throw AppError.genericError(message: "could not find \(Constants.quoteAssetSymbol) asset in account balances")
            }
        }
    }

    private func updateAccountAssetList(exchangeInfo: ExchangeInfo,
                                        accountBalanceList: [AccountBalance],
                                        priceList: [Price]) throws {
        if self.accountAssetList.isEmpty {
            for balance in accountBalanceList.filter({
                self.exchangeInfo.symbols.map({ $0.marketPairSymbol }).contains($0.marketPairSymbol) &&
                !self.tradingExclusionAssetList.contains($0.asset) })
            {
                guard let price = priceList.filter({ $0.marketPairSymbol == balance.marketPairSymbol }).first else {
                    throw AppError.genericError(message: "could not find price for \(balance.marketPairSymbol)")
                }

                let accountAsset = AccountAsset(name: balance.asset,
                                                free: balance.free,
                                                locked: balance.locked,
                                                price: price.amount)

                self.accountAssetList.append(accountAsset)
            }
        } else {
            for asset in self.accountAssetList {
                guard let price = priceList.filter({ $0.marketPairSymbol == asset.marketPairSymbol }).first else {
                    throw AppError.genericError(message: "could not find price for \(asset.marketPairSymbol)")
                }

                guard let balance = accountBalanceList.filter({ $0.marketPairSymbol == asset.marketPairSymbol }).first else {
                    throw AppError.genericError(message: "could not find account balance for \(asset.marketPairSymbol)")
                }

                guard let index = self.accountAssetList.firstIndex(where: { $0.marketPairSymbol == asset.marketPairSymbol }) else {
                    throw AppError.genericError(message: "could not find index in account asset list for \(asset.marketPairSymbol)")
                }

                if balance.free != self.accountAssetList[index].free ||
                    balance.locked != self.accountAssetList[index].locked {
                    self.updateAccountAsset(marketPairSymbol: asset.marketPairSymbol,
                                            shouldUpdateLastTrade: true)
                }

                self.accountAssetList[index].free = balance.free
                self.accountAssetList[index].locked = balance.locked
                self.accountAssetList[index].price = price.amount
            }
        }
    }

    func updateAccountAsset(marketPairSymbol: String, shouldUpdateLastTrade: Bool) {
        if let index = self.accountAssetList.firstIndex(where: { $0.marketPairSymbol == marketPairSymbol }) {
            print("\(marketPairSymbol) \(shouldUpdateLastTrade)")

            self.accountAssetList[index].shouldUpdateLastTrade = shouldUpdateLastTrade
        }
    }

    func updateAccountAsset(marketPairSymbol: String, lastTrade: Trade) {
        if let index = self.accountAssetList.firstIndex(where: { $0.marketPairSymbol == marketPairSymbol }) {
            self.accountAssetList[index].lastTrade = lastTrade
        }
    }

    private func updateLastTrades() -> Future<Void, Error> {
        let future = Future<Void, Error> { promise in
            var delay = 0.0
            var tradeListResponseCount = 0

            do {
                let assetList = self.accountAssetList.filter { $0.shouldUpdateLastTrade }

                guard assetList.count >= 1 else {
                    promise(.success(()))
                    return
                }

                for asset in assetList {
                    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                        do {
                            try self.dataLayer.getTradeList(tradingPairSymbol: asset.marketPairSymbol)
                                .sink(receiveCompletion: { completion in
                                    if case let .failure(error) = completion {
                                        promise(.failure(error))
                                    }
                                }, receiveValue: { tradeList in
                                    tradeListResponseCount += 1

                                    self.updateAccountAsset(marketPairSymbol: asset.marketPairSymbol,
                                                            shouldUpdateLastTrade: false)

                                    if let lastTrade = tradeList.last {
                                        self.updateAccountAsset(marketPairSymbol: asset.marketPairSymbol,
                                                                lastTrade: lastTrade)

                                        if self.lastTradesUpdated {
                                            self.sendEmail(trade: lastTrade)
                                        }
                                    }

                                    print("\(tradeListResponseCount) \(assetList.count)")

                                    if tradeListResponseCount == assetList.count {
                                        promise(.success(()))
                                    }
                                })
                                .store(in: &self.subscribers)
                        } catch {
                            promise(.failure(error))
                        }
                    }

                    delay += Constants.serverRequestDelayInterval
                }
            }
        }

        return future
    }

    private func sendEmail(trade: Trade) {
        guard !trade.isBuyer else {
            return
        }

        var subject: String
        var text: String

        if trade.isMaker {
            subject = "limit maker sell order filled"
        } else {
            subject = "stop loss sell order filled"
        }

        text = "\(trade.marketPairSymbol):\n\n"
        text += "Sold \(trade.quantity) for $\(trade.quoteQuantity). price = \(trade.price)"

        Logger.shared.add(entry: "\(subject): \(text)")

        self.smtpClient.sendEmail(subject: subject, text: text)
            .sink { completion in
                if case let .failure(error) = completion {
                    Logger.shared.add(entry: error.localizedDescription)
                }
            } receiveValue: { _ in }
            .store(in: &self.subscribers)
    }
}
