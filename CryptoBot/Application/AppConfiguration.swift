//
//  AppConfiguration.swift
//  CryptoBot
//
//  Created by Andre Muis on 4/22/22.
//

import Foundation

struct AppConfiguration {
    enum URLKey: String {
        case byBitTradingPairsURLKey = "ByBitTradingPairsURL"
        case byBitPricesURLKey = "ByBitPricesURL"
        case byBitAccountURLKey = "ByBitAccountURL"
        case byBitOrderURLKey = "ByBitOrderURL"
    }

    private static var endpoints: [String: String]? {
        return Bundle.main.object(forInfoDictionaryKey: "Endpoints") as? [String: String]
    }

    static func getURL(for key: URLKey) throws -> URL {
        guard let urlAsString = self.endpoints?[key.rawValue] else {
            throw AppError.genericError(message: "unable to retrieve endpoint URL from info.plist")
        }

        guard let url = URL(string: urlAsString) else {
            throw AppError.genericError(message: "unable to convert string to URL")
        }

        return url
    }
}
