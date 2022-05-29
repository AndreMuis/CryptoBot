//
//  BinanceUSError.swift
//  CryptoBot
//
//  Created by Andre Muis on 4/30/22.
//

import Foundation

struct BinanceUSError: Decodable, CustomStringConvertible {
    let code: Int
    let message: String

    enum CodingKeys: String, CodingKey {
        case code = "code"
        case message = "msg"
    }

    var description: String {
        return "code: \(self.code) message: \(self.message)"
    }
}
