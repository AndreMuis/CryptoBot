//
//  ExchangeInfoEndpoint.swift
//  Crypto Bot
//
//  Created by Andre Muis on 5/28/22.
//

import Foundation

struct ExchangeInfoEndpoint: Endpoint {
    let url: URL
    let httpMethod: String
    let httpHeaderFieldDictionary: [String : String]?

    init() throws {
        self.url = try AppConfiguration.getURL(for: .binanceUSExchangeInfoURLKey)
        self.httpMethod = "GET"
        self.httpHeaderFieldDictionary = nil
    }
}
