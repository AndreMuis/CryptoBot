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
    let httpHeaderFieldDictionary: [String : String]?

    init() throws {
        self.httpMethod = "GET"
        self.httpHeaderFieldDictionary = nil

        self.url = try AppConfiguration.getURL(for: .binanceUSPricesURLKey)
    }
}
