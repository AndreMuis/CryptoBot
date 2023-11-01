//
//  DataLayer.swift
//  CryptoBot
//
//  Created by Andre Muis on 4/23/22.
//

import Combine
import Foundation

class DataLayer: ObservableObject {
    func getExchangeInfo() async throws -> ExchangeInfo {
        let endpoint = try ExchangeInfoEndpoint()
        let data = try await self.downloadData(request: endpoint.request)
        let info = try JSONDecoder().decode(ExchangeInfo.self, from: data)

        return info
    }

    func getPriceList() async throws -> [Price] {
        let endpoint = try PriceListEndpoint()
        let data = try await self.downloadData(request: endpoint.request)
        let list = try JSONDecoder().decode([Price].self, from: data)

        return list
    }

    func getAccountBalanceList() async throws -> [AccountBalance] {
        let endpoint = try AccountEndpoint()
        let data = try await self.downloadData(request: endpoint.request)

        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
        guard let balancesArrayJSON = json?["balances"] as? [[String : Any]] else {
            throw AppError.genericError(message: "unable to extract balances element from JSON")
        }
        let balancesArrayData = try JSONSerialization.data(withJSONObject: balancesArrayJSON, options: [])

        let list = try JSONDecoder().decode([AccountBalance].self, from: balancesArrayData)

        return list
    }

    func createBuyOrder(marketPairSymbol: String, quoteQuantity: Decimal, quotePrecision: Int) async throws -> OrderResponse {
        let endpoint = try OrderEndpoint(marketPairSymbol: marketPairSymbol,
                                         side: .buy,
                                         quoteQuantity: quoteQuantity,
                                         quotePrecision: quotePrecision)


        let data = try await self.downloadData(request: endpoint.request)
        let response = try JSONDecoder().decode(OrderResponse.self, from: data)

        return response
    }

    func createSellOrder(marketPairSymbol: String, quoteQuantity: Decimal, quotePrecision: Int) async throws -> OrderResponse {
        let endpoint = try OrderEndpoint(marketPairSymbol: marketPairSymbol,
                                         side: .sell,
                                         quoteQuantity: quoteQuantity,
                                         quotePrecision: quotePrecision)

        let data = try await self.downloadData(request: endpoint.request)
        let response = try JSONDecoder().decode(OrderResponse.self, from: data)

        return response
    }

    private func downloadData(request: URLRequest) async throws -> Data {
        do {
            let (data, _) = try await URLSession.shared.data(for: request)

            if let error = try? JSONDecoder().decode(BinanceUSError.self, from: data) {
                throw AppError.genericError(message: error.description)
            } else {
                return data
            }
        }
    }
}
