//
//  DashboardView.swift
//  Crypto Bot
//
//  Created by Andre Muis on 5/16/22.
//

import SwiftUI

struct DashboardView: View {
    @ObservedObject private var viewModel: DashboardViewModel
    @ObservedObject private var tradingEngine: TradingEngine
    @ObservedObject private var userAccount: UserAccount

    private var accountBalanceListColumns = [
        GridItem(.flexible(), alignment: .leading),
        GridItem(.flexible(), alignment: .leading),
        GridItem(.flexible(), alignment: .leading),
        GridItem(.flexible(), alignment: .leading),
        GridItem(.flexible(), alignment: .leading)]

    init(tradingEngine: TradingEngine, userAccount: UserAccount) {
        self.viewModel = DashboardViewModel(tradingEngine: tradingEngine)
        self.tradingEngine = tradingEngine
        self.userAccount = userAccount
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack() {
                Text("Balance: \(self.userAccount.balance.currencyAsString)")
                    .padding(5)
                    .background(Color.white)

                Text("Quote Balance: \(self.userAccount.quoteBalance.currencyAsString)")
                    .padding(5)
                    .background(Color.white)

                Text("Quote Symbol: \(Constants.quoteSymbol)")
                    .padding(5)
                    .background(Color.white)

                Text("Portfolio Balance: \(self.userAccount.portfolioBalance.currencyAsString)")
                    .padding(5)
                    .background(Color.white)

                Text("# Assets: \(self.userAccount.assetCount)")
                    .padding(5)
                    .background(Color.white)
            }

            ScrollView {
                LazyVGrid(columns: self.accountBalanceListColumns) {
                    Group {
                        Text("Symbol")
                        Text("Free")
                        Text("Locked")
                        Text("Price")
                        Text("Balance")
                    }
                    .padding(.bottom, 1)
                    .font(.headline)

                    ForEach(self.userAccount.assetListSortedByBalance, id: \.self) { asset in
                        Group {
                            Text("\(asset.symbol)")
                            Text("\(asset.freeAsString)")
                            Text("\(asset.lockedAsString)")
                            Text("\(asset.priceAsString)")
                            Text("\(asset.balanceAsString)")
                        }
                        .foregroundColor(asset.canTrade ? (asset.isProfitable ? .blue : .black) : .gray)
                    }
                }
                .padding(5)
                .background(Color.white)
            }

            Spacer()

            HStack {
                Text("Status: \(self.tradingEngine.status.rawValue)")
                    .padding(5)
                    .background(Color.white)

                Text("Last run date: \(self.tradingEngine.lastRunDateAsString)")
                    .padding(5)
                    .background(Color.white)
            }

            HStack {
                Text("Error Message: \(self.tradingEngine.error?.localizedDescription ?? "")")
                    .padding(5)
                    .background(Color.white)

                Spacer()
            }
        }
        .frame(maxWidth: .infinity,
               maxHeight: .infinity,
               alignment: .topLeading)
        .padding(10)
        .onAppear(perform: {
            self.viewModel.startTradingEngine()
        })
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        let userAccount = UserAccount()

        DashboardView(tradingEngine: TradingEngine(userAccount: userAccount), userAccount: userAccount)
    }
}
