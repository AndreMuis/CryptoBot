//
//  AccountBalance.swift
//  CryptoBot
//
//  Created by Andre Muis on 4/24/22.
//

import Foundation

struct AccountBalance: Decodable {
    let coinList: [AccountCoin]

    enum CodingKeys: String, CodingKey {
        case coinList = "coin"
    }

    func coin(symbol: String) -> AccountCoin? {
        return self.coinList.filter({ $0.symbol == symbol }).first
    }
}
