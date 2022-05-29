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

    private let userAccount = UserAccount()

    private var runCount = 0

    @Published private(set) var accountAssetList: [AccountAsset]?
    @Published private(set) var quoteBalance: Decimal?
    @Published private(set) var portfolioBalance: Decimal?
    @Published private(set) var lastRunDate: Date?
    @Published private(set) var status: TradingEngineStatus = .notStarted
    @Published private(set) var error: Error?

    private var subscribers = Set<AnyCancellable>()

    func start() {
        if case .notStarted = self.status {
            self.run()

            Timer.publish(every: TimeInterval(Constants.tradingEngineRunIntervalInSeconds),
                          on: .main,
                          in: .default)
                .autoconnect()
                .sink { _ in
                    if case .idle = self.status  {
                        self.run()
                    }
                }
                .store(in: &self.subscribers)
        }
    }

    private func run() {
        self.status = .running

        self.lastRunDate = Date()
        self.error = nil

        self.runCount += 1

        self.userAccount.downloadData()
            .sink { completion in
                self.accountAssetList = self.userAccount.accountAssetList

                self.quoteBalance = self.userAccount.quoteBalance
                self.portfolioBalance = self.userAccount.portfolioBalance

                switch completion {
                case .finished:
                    do {
                        try self.createBuyOrders()
                            .sink { completion in
                                if case let .failure(error) = completion {
                                    self.error = error
                                }

                                self.status = .idle
                            } receiveValue: { _ in }
                            .store(in: &self.subscribers)
                    } catch {
                        self.error = error
                        self.status = .idle
                    }

                case .failure(let error):
                    self.error = error
                    self.status = .idle
                }
            } receiveValue: { _ in }
            .store(in: &self.subscribers)
    }

    private func createBuyOrders() throws -> Future<Void, Error> {
        let promise = Future<Void, Error> { promise in
            let klineIntervalList = KlineInterval.tradableIntervals.filter {
                (self.runCount * Constants.tradingEngineRunIntervalInSeconds) % $0.durationInSeconds == 0
            }

            let symbols = self.userAccount.accountAssetList.map { $0.marketPairSymbol }

            self.getKlineLists(klineIntervalList: klineIntervalList,
                               marketPairSymbolList: symbols)
                .sink { completion in
                    if case let .failure(error) = completion {
                        promise(.failure(error))
                    }
                } receiveValue: { klineLists in
                    var assetBuyList = Set<AccountAsset>()

                    for interval in klineIntervalList {
                        for asset in self.userAccount.accountAssetList {
                            guard let statistics = self.userAccount.priceChangeStatisticsList.filter({ $0.marketPairSymbol == asset.marketPairSymbol }).first,
                                  statistics.priceChangePercent > 0.0 else {
                                      continue
                                  }

                            guard let klineList = klineLists.filter( {
                                $0.first?.interval == interval &&
                                $0.first?.marketPairSymbol == asset.marketPairSymbol } ).first else {
                                promise(.failure(AppError.genericError(message: "could not find kline list for \(asset.marketPairSymbol)")))
                                    return
                            }

                            guard klineList.count == Constants.klineListLimit else {
                                Logger.shared.add(entry: "\(asset.marketPairSymbol) returned less than \(Constants.klineListLimit) klines" )
                                continue
                            }

                            let rsi = TradingIndicators.rsi(klineList: klineList, period: Constants.rsiPeriod)
                            let mfi = TradingIndicators.mfi(klineList: klineList, period: Constants.mfiPeriod)

                            let zeroVolumeCount = klineList.filter({ $0.volume == 0.0 }).count

                            guard let quoteBalance = self.userAccount.quoteBalance,
                                  Constants.purchaseAmount < quoteBalance,
                                  (asset.lastTrade == nil || asset.lastTrade?.isBuyer == false),
                                  rsi < Constants.rsiSellTheshold && mfi < Constants.mfiSellTheshold && zeroVolumeCount == 0 else {
                                      continue
                                  }

                            assetBuyList.insert(asset)
                            self.userAccount.quoteBalance = quoteBalance - Constants.purchaseAmount
                        }
                    }

                    var publishers = [AnyPublisher<OrderResponse, Error>]()

                    do {
                        for asset in assetBuyList {
                            let publisher = try self.dataLayer.createBuyOrder(marketPairSymbol: asset.marketPairSymbol,
                                                                              quoteOrderQuantity: Constants.purchaseAmount)

                            publishers.append(publisher)
                        }
                    } catch {
                        promise(.failure(error))
                    }

                    Publishers.MergeMany(publishers)
                        .collect()
                        .sink { completion in
                            if case let .failure(error) = completion {
                                promise(.failure(error))
                            }
                        } receiveValue: { orderResponseList in
                            do {
                                try self.createSellOrders(orderResponseList: orderResponseList)
                                    .sink { completion in
                                        switch completion {
                                        case .finished:
                                            promise(.success(()))

                                        case .failure(let error):
                                            promise(.failure(error))
                                        }
                                    } receiveValue: { _ in }
                                    .store(in: &self.subscribers)
                            } catch {
                                promise(.failure(error))
                            }
                        }
                        .store(in: &self.subscribers)
                }.store(in: &self.subscribers)
        }

        return promise
    }

    private func createSellOrders(orderResponseList: [OrderResponse]) throws -> Future<Void, Error> {
        let promise = Future<Void, Error> { promise in
            var publishers = [AnyPublisher<OCOOrderResponse, Error>]()

            let filledOrderResponseList = orderResponseList.filter { $0.status == .filled }

            for orderResponse in filledOrderResponseList {
                do {
                    print("\nbuy order response: \(orderResponse)")

                    guard let symbolFilter = self.userAccount.exchangeInfo.symbols.filter({ $0.marketPairSymbol == orderResponse.marketPairSymbol }).first else {
                        throw AppError.genericError(message: "could not find symbol filter for \(orderResponse.marketPairSymbol)")
                    }

                    guard let price = self.userAccount.priceList.filter({ $0.marketPairSymbol == orderResponse.marketPairSymbol }).first?.amount else {
                        Logger.shared.add(entry: "Could not find Price for \(orderResponse.marketPairSymbol)")
                        continue
                    }

                    guard let quantity = orderResponse.executedQuantity.roundDown(fractionDigits: symbolFilter.lotStepSize.significantFractionDigits) else {
                        throw AppError.genericError(message: "Unable to round down quantity and limit to \(symbolFilter.lotStepSize.significantFractionDigits) fraction digits.")
                    }

                    print("initial price: \(price), initial quantity: \(quantity)")

                    let limitPrice = price * Constants.priceSellMaxMultiplier

                    guard let limitPrice = limitPrice.roundDown(fractionDigits: symbolFilter.priceTickSize.significantFractionDigits) else {
                        throw AppError.genericError(message: "Unable to round down price and limit to \(symbolFilter.priceTickSize.significantFractionDigits) fraction digits.")
                    }

                    let stopPrice = price * Constants.priceSellMinMultiplier

                    guard let stopPrice = stopPrice.roundDown(fractionDigits: symbolFilter.priceTickSize.significantFractionDigits) else {
                        throw AppError.genericError(message: "Unable to round down stop price and limit to \(symbolFilter.priceTickSize.significantFractionDigits) fraction digits.")
                    }

                    print("final price: \(price), final stop price: \(stopPrice), final quantity: \(quantity)")

                    let publisher = try self.dataLayer.createSellOrder(marketPairSymbol: orderResponse.marketPairSymbol,
                                                                       quantity: quantity,
                                                                       limitPrice: limitPrice,
                                                                       stopPrice: stopPrice)

                    publishers.append(publisher)
                } catch {
                    promise(.failure(error))
                }
            }

            Publishers.MergeMany(publishers)
                .collect()
                .sink { completion in
                    switch completion {
                    case .finished:
                        promise(.success(()))

                    case .failure(let error):
                        promise(.failure(error))
                    }

                } receiveValue: { ocoOrderResponseList in
                    self.sendEmails(orderResponseList: orderResponseList, ocoOrderResponseList: ocoOrderResponseList)
                }
                .store(in: &self.subscribers)
        }

        return promise
    }

    private func getKlineLists(klineIntervalList: [KlineInterval], marketPairSymbolList: [String]) -> Future<[[Kline]], Error> {
        let promise = Future<[[Kline]], Error> { promise in
            var publishers = [AnyPublisher<[Kline], Error>]()

            for interval in klineIntervalList {
                for symbol in marketPairSymbolList {
                    do {
                        let publisher = try self.dataLayer.getKlineList(marketPairSymbol: symbol,
                                                                        interval: interval,
                                                                        limit: Constants.klineListLimit)
                        publishers.append(publisher)
                    } catch {
                        promise(.failure(error))
                    }
                }
            }

            Publishers.MergeMany(publishers)
                .collect()
                .sink { completion in
                    if case let .failure(error) = completion {
                        promise(.failure(error))
                    }
                } receiveValue: { klineLists in
                    promise(.success(klineLists))
                }.store(in: &self.subscribers)
        }

        return promise
    }

    private func sendEmails(orderResponseList: [OrderResponse], ocoOrderResponseList: [OCOOrderResponse]) {
        for orderResponse in orderResponseList {
            var subject: String
            var text: String

            let ocoOrderResponse = ocoOrderResponseList.filter { $0.marketPairSymbol == orderResponse.marketPairSymbol }.first

            text = "\(orderResponse.marketPairSymbol):\n\n"

            if case .filled = orderResponse.status {
                subject = "buy order filled"
                text += "Bought \(orderResponse.executedQuantity) for $\(orderResponse.cummulativeQuoteQuantity)\n\n"
            } else {
                subject = "buy order not filled"
                text += "Status: \(orderResponse.status.rawValue)\n\n"
            }

            if let response = ocoOrderResponse {
                if case .executing = ocoOrderResponse?.listOrderStatus {
                    subject += ", sell order executing"
                    text += "Placed limit-maker sell order. price = \(response.orderReports[1].price.stringValue)\n"
                    text += "Placed stop-loss sell order. price = \(response.orderReports[0].stopPrice?.stringValue ?? "")"
                } else {
                    subject += ", sell order not executing"
                    text += "Status: \(response.listOrderStatus.rawValue)"
                }
            } else {
                subject += ", sell order not executing"
                text += "Status: sell order ceartion not attempted"
            }

            Logger.shared.add(entry: "\(subject): \(text)")

            self.smtpClient.sendEmail(subject: subject, text: text)
                .sink { completion in
                    if case let .failure(error) = completion {
                        self.error = error
                    }
                } receiveValue: { _ in }
                .store(in: &self.subscribers)
        }
    }
}
