//
//  CryptoBotApp.swift
//  CryptoBot
//
//  Created by Andre Muis on 4/22/22.
//

import SwiftUI

@main
struct CryptoBotApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
                .frame(width: Constants.windowSize.width,
                       height: Constants.windowSize.height)
                .navigationTitle("Crypto Bot")
        }
    }
}
