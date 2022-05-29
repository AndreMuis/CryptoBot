//
//  RootView.swift
//  CryptoBot
//
//  Created by Andre Muis on 4/22/22.
//

import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Text("Dashboard")
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
        RootView()
    }
}
