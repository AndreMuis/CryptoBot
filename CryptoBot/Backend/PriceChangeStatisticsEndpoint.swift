//
//  PriceChangeStatisticsEndpoint.swift
//  Crypto Bot
//
//  Created by Andre Muis on 4/30/22.
//

import Foundation

struct PriceChangeStatisticsEndpoint: Endpoint {
    let url: URL
    let httpMethod: String
    let httpHeaderFieldDictionary: [String : String]?

    init() throws {
        self.httpMethod = "GET"
        self.httpHeaderFieldDictionary = nil

        self.url = try AppConfiguration.getURL(for: .binanceUSPriceChangeStatisticsURLKey)
    }
}
