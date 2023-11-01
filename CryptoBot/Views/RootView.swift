//
//  RootView.swift
//  CryptoBot
//
//  Created by Andre Muis on 4/22/22.
//

import SwiftUI

struct RootView: View {
    var tradingEngine: TradingEngine
    var userAccount: UserAccount

    var body: some View {
        TabView {
            DashboardView(tradingEngine: self.tradingEngine,
                          userAccount: self.userAccount)
                .tabItem {
                    Text("Dashboard")
                }

            TradingView(userAccount: self.userAccount)
                .tabItem {
                    Text("Trade")
                }

            LogView()
                .tabItem {
                    Text("Logs")
                }

            SettingsView()
                .tabItem {
                    Text("Settings")
                }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        let userAccount = UserAccount()

        RootView(tradingEngine: TradingEngine(userAccount: userAccount),
                 userAccount: userAccount)
    }
}
