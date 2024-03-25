//
//  DataLayer.swift
//  CryptoBot
//
//  Created by Andre Muis on 4/23/22.
//

import Combine
import Foundation

class DataLayer: ObservableObject {
    func getTradingPairList() async throws -> [TradingPair] {
        let endpoint = try TradingPairListEndpoint()
        let resultJSON = try await self.downloadData(request: endpoint.createRequest())

        guard let listJSON = resultJSON["list"] as? [[String : Any]] else {
            throw AppError.genericError(message: "Unable to extract list element from trading pairs JSON")
        }

        let listData = try JSONSerialization.data(withJSONObject: listJSON, options: [])
        let list = try JSONDecoder().decode([TradingPair].self, from: listData)

        return list
    }

    func getPriceList() async throws -> [Price] {
        let endpoint = try PriceListEndpoint()
        let resultJSON = try await self.downloadData(request: endpoint.createRequest())

        guard let listJSON = resultJSON["list"] as? [[String : Any]] else {
            throw AppError.genericError(message: "unable to extract list element from prices JSON")
        }

        let listData = try JSONSerialization.data(withJSONObject: listJSON, options: [])
        let list = try JSONDecoder().decode([Price].self, from: listData)

        return list
    }

    func getAccountBalance() async throws -> AccountBalance {
        let endpoint = try AccountEndpoint()
        let resultJSON = try await self.downloadData(request: endpoint.createRequest())

        guard let listJSON = resultJSON["list"] as? [[String : Any]] else {
            throw AppError.genericError(message: "unable to extract balances element from JSON")
        }

        let listData = try JSONSerialization.data(withJSONObject: listJSON, options: [])
        let balanceList = try JSONDecoder().decode([AccountBalance].self, from: listData)

        if let balance = balanceList.first {
            return balance
        } else if balanceList.count == 0 {
            throw AppError.genericError(message: "No account balances found")
        } else {
            throw AppError.genericError(message: "More than one account balance found")
        }
    }

    func createBuyOrder(tradingPairSymbol: String, quoteQuantity: Decimal, quotePrecision: Decimal) async throws {
        let endpoint = try OrderEndpoint(tradingPairSymbol: tradingPairSymbol,
                                         side: .buy,
                                         quoteQuantity: quoteQuantity,
                                         quotePrecision: quotePrecision)

        _ = try await self.downloadData(request: endpoint.createRequest())
    }

    func createSellOrder(tradingPairSymbol: String, quoteQuantity: Decimal, quotePrecision: Decimal) async throws {
        let endpoint = try OrderEndpoint(tradingPairSymbol: tradingPairSymbol,
                                         side: .sell,
                                         quoteQuantity: quoteQuantity,
                                         quotePrecision: quotePrecision)

        _ = try await self.downloadData(request: endpoint.createRequest())
    }

    private func downloadData(request: URLRequest) async throws -> [String: Any] {
        do {
            let (data, _) = try await URLSession.shared.data(for: request)

            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else {
                print(String(data: data, encoding: .utf8) as Any)
                throw AppError.genericError(message: "Unable to convert response data to JSON")
            }

            guard let code = json["retCode"] as? Int,
                  let message = json["retMsg"] as? String,
                  let extendedInfo = json["retExtInfo"] as? [String: Any] else {
                self.outputToConsole(jsonObject: json)
                throw AppError.genericError(message: "Unable to parse response JSON")
            }

            guard code == Constants.responseCodeOK else {
                throw AppError.genericError(message: "code: \(code), message: \(message), extendedInfo: \(extendedInfo)")
            }

            guard let resultJSON = json["result"] as? [String: Any] else {
                self.outputToConsole(jsonObject: json)
                throw AppError.genericError(message: "Unable to parse result dictionary from response JSON")
            }

            return resultJSON
        }
    }

    private func outputToConsole(jsonObject: Any) {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
            return
        }

        print(String(decoding: jsonData, as: UTF8.self))
    }
}
