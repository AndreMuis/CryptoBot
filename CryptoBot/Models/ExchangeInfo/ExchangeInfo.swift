//
//  ExchangeInfo.swift
//  Crypto Bot
//
//  Created by Andre Muis on 5/28/22.
//

import Foundation

struct ExchangeInfo: Decodable {
    let symbols: [ExchangeInfoSymbol]

    enum CodingKeys: String, CodingKey {
        case symbols = "symbols"
    }
}
