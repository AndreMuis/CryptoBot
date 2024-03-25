//
//  TradingPairListEndpoint.swift
//  Crypto Bot
//
//  Created by Andre Muis on 5/28/22.
//

import Foundation

struct TradingPairListEndpoint: Endpoint {
    let url: URL
    let httpMethod: String
    let httpHeaderFields: [String : String]?
    let httpPOSTFields: [String : String]?

    init() throws {
        var url = try AppConfiguration.getURL(for: .byBitTradingPairsURLKey)

        let queryItems = [
            URLQueryItem(name: Constants.APIQueryItemNames.productCategory,
                         value: ProductCategory.spot.rawValue)
        ]

        try url.add(queryItems: queryItems)

        self.url = url
        self.httpMethod = "GET"
        self.httpHeaderFields = nil
        self.httpPOSTFields = nil
    }
}
