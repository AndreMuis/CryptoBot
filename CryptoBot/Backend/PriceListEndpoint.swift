//
//  PriceListEndpoint.swift
//  CryptoBot
//
//  Created by Andre Muis on 4/28/22.
//

import Foundation

struct PriceListEndpoint: Endpoint {
    let url: URL
    let httpMethod: String
    let httpHeaderFields: [String : String]?
    let httpPOSTFields: [String : String]?

    init() throws {
        var url = try AppConfiguration.getURL(for: .byBitPricesURLKey)

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
