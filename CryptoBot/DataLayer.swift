//
//  DataLayer.swift
//  CryptoBot
//
//  Created by Andre Muis on 4/23/22.
//

import Combine
import Foundation

class DataLayer: ObservableObject {
    func getExchangeInfo() throws -> AnyPublisher<ExchangeInfo, Error> {
        do {
            let endpoint = try ExchangeInfoEndpoint()

            let publisher = self.getBinanceUSData(endpoint: endpoint)
                .decode(type: ExchangeInfo.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()

            return publisher
        }
    }

    func getPriceList() throws -> AnyPublisher<[Price], Error> {
        do {
            let endpoint = try PriceListEndpoint()

            let publisher = self.getBinanceUSData(endpoint: endpoint)
                .decode(type: [Price].self, decoder: JSONDecoder())
                .eraseToAnyPublisher()

            return publisher
        }
    }

    func getPriceChangeStatisticsList() throws -> AnyPublisher<[PriceChangeStatistics], Error> {
        do {
            let endpoint = try PriceChangeStatisticsEndpoint()

            let publisher = self.getBinanceUSData(endpoint: endpoint)
                .decode(type: [PriceChangeStatistics].self, decoder: JSONDecoder())
                .eraseToAnyPublisher()

            return publisher
        }
    }

    func getKlineList(marketPairSymbol: String,
                      interval: KlineInterval,
                      limit: Int) throws -> AnyPublisher<[Kline], Error> {
        do {
            let endpoint = try KlineListEndpoint(marketPairSymbol: marketPairSymbol,
                                                 interval: interval,
                                                 limit: limit)

            let publisher = self.getBinanceUSData(endpoint: endpoint)
                .tryMap { data -> [Kline] in
                    var klines = [Kline]()

                    if let valuesArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[Any]] {
                        for values in valuesArray {
                            let kline = try Kline(marketPairSymbol: marketPairSymbol,
                                                  interval: interval,
                                                  values: values)
                            klines.append(kline)
                        }

                        return klines
                    } else {
                        throw AppError.genericError(message: "unable to convert array of Any to JSON object")
                    }
                }
                .eraseToAnyPublisher()

            return publisher
        }
    }

    func getAccountBalanceList() throws -> AnyPublisher<[AccountBalance], Error> {
        do {
            let endpoint = try AccountEndpoint()

            let publisher = self.getBinanceUSData(endpoint: endpoint)
                .tryMap { data -> Data in
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]

                    guard let balancesArrayJSON = json?["balances"] as? [[String : Any]] else {
                        throw AppError.genericError(message: "unable to extract balances element from JSON")
                    }

                    let balancesArrayData = try JSONSerialization.data(withJSONObject: balancesArrayJSON, options: [])

                    return balancesArrayData
                }
                .decode(type: [AccountBalance].self, decoder: JSONDecoder())
                .eraseToAnyPublisher()

            return publisher
        }
    }

    func getTradeList(tradingPairSymbol: String) throws -> AnyPublisher<[Trade], Error> {
        do {
            let endpoint = try TradeListEndpoint(tradingPairSymbol: tradingPairSymbol)

            let publisher = self.getBinanceUSData(endpoint: endpoint)
                .decode(type: [Trade].self, decoder: JSONDecoder())
                .eraseToAnyPublisher()

            return publisher
        }
    }

    func createBuyOrder(marketPairSymbol: String,
                        quoteOrderQuantity: Decimal) throws -> AnyPublisher<OrderResponse, Error> {
        do {
            let endpoint = try OrderEndpoint(marketPairSymbol: marketPairSymbol,
                                             type: .market,
                                             quoteOrderQuantity: quoteOrderQuantity)

            let publisher = self.getBinanceUSData(endpoint: endpoint)
                .decode(type: OrderResponse.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()

            return publisher
        }
    }

    func createSellOrder(marketPairSymbol: String,
                         quantity: Decimal,
                         limitPrice: Decimal,
                         stopPrice: Decimal) throws -> AnyPublisher<OCOOrderResponse, Error> {
        do {
            let endpoint = try OCOOrderEndpoint(marketPairSymbol: marketPairSymbol,
                                                quantity: quantity,
                                                limitPrice: limitPrice,
                                                stopPrice: stopPrice,
                                                stopLimitPrice: stopPrice,
                                                stopLimitTimeInForce: .goodTillCancelled)
            let publisher = self.getBinanceUSData(endpoint: endpoint)
                .decode(type: OCOOrderResponse.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()

            return publisher
        }
    }

    private func getBinanceUSData(endpoint: Endpoint) -> AnyPublisher<Data, Error> {
        let publisher = URLSession.dataTaskPublisher(for: endpoint)
            .tryMap { data -> Data in
                let decoder = JSONDecoder()

                if let error = try? decoder.decode(BinanceUSError.self, from: data) {
                    throw AppError.genericError(message: error.description)
                } else {
                    return data
                }
            }
            .eraseToAnyPublisher()

        return publisher
    }
}
