//
//  CryptoBotApp.swift
//  CryptoBot
//
//  Created by Andre Muis on 4/22/22.
//

import SwiftUI

@main
struct CryptoBotApp: App {
    let tradingEngine: TradingEngine
    let userAccount: UserAccount

    init() {
        let userAccount = UserAccount()

        self.tradingEngine = TradingEngine(userAccount: userAccount)
        self.userAccount = userAccount
    }

    var body: some Scene {
        WindowGroup {
            RootView(tradingEngine: self.tradingEngine,
                     userAccount: self.userAccount)
                .navigationTitle("Crypto Bot")
        }
    }
}
