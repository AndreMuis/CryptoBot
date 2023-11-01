//
//  DashboardViewModel.swift
//  CryptoBot
//
//  Created by Andre Muis on 4/22/22.
//

import Combine

class DashboardViewModel: ObservableObject {
    private var tradingEngine: TradingEngine

    init(tradingEngine: TradingEngine) {
        self.tradingEngine = tradingEngine
    }

    func startTradingEngine() {
        self.tradingEngine.start()
    }
}
