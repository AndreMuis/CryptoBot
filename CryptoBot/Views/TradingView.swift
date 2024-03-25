//
//  TradingView.swift
//  Crypto Bot
//
//  Created by Andre Muis on 10/31/23.
//

import SwiftUI

struct TradingView: View {
    @ObservedObject private var viewModel: TradingViewModel
    @ObservedObject private var tradingEngine: TradingEngine
    @ObservedObject private var userAccount: UserAccount

    init(tradingEngine: TradingEngine, userAccount: UserAccount) {
        self.viewModel = TradingViewModel(userAccount: userAccount)
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
            }

            ScrollView {
                Grid(alignment: .leading, horizontalSpacing: 20.0) {
                    GridRow {
                        Text("Symbol")
                        Text("Balance")
                        Text("Min Trade")
                    }
                    .padding(.bottom, 3)
                    .font(.headline)

                    ForEach(self.userAccount.assetListSortedByBalance, id: \.self) { accountAsset in
                        GridRow {
                            Text("\(accountAsset.symbol)")
                            Text("\(accountAsset.balanceAsString)")
                            Text("\(accountAsset.minTradeQuoteQuantity.currencyAsString)")

                            Button("Buy \(accountAsset.buyBalanceAsString)") {
                                self.viewModel.buy(accountAsset: accountAsset)
                            }
                            .disabled(!accountAsset.canBuy)
                            .opacity(accountAsset.canBuy ? 1.0 : 0.0)

                            Button("Sell \(accountAsset.sellBalanceAsString)") {
                                self.viewModel.sell(accountAsset: accountAsset)
                            }
                            .disabled(!accountAsset.canSell)
                            .opacity(accountAsset.canSell ? 1.0 : 0.0)
                        }
                        .foregroundColor(accountAsset.canTrade ? .black : .gray)
                    }
                }
                .padding(5)
            }
            .background(Color.white)

            HStack {
                Text("Error Message: \(self.viewModel.error?.localizedDescription ?? "")")
                    .padding(5)
                    .background(Color.white)

                Spacer()
            }
        }
        .frame(maxWidth: .infinity,
               maxHeight: .infinity,
               alignment: .topLeading)
        .padding(10)
    }
}

struct TradingView_Previews: PreviewProvider {
    static var previews: some View {
        let userAccount = UserAccount()

        DashboardView(tradingEngine: TradingEngine(userAccount: userAccount), userAccount: userAccount)
    }
}
