//
//  DashboardView.swift
//  Crypto Bot
//
//  Created by Andre Muis on 5/16/22.
//

import SwiftUI

struct DashboardView: View {
    @ObservedObject private var viewModel = DashboardViewModel()

    private var accountBalanceListColumns = [
        GridItem(.flexible(), alignment: .leading),
        GridItem(.flexible(), alignment: .leading),
        GridItem(.flexible(), alignment: .leading),
        GridItem(.flexible(), alignment: .leading),
        GridItem(.flexible(), alignment: .leading),
        GridItem(.flexible(), alignment: .leading)]

    var body: some View {
        VStack(alignment: .leading) {
            HStack() {
                Text("Balance: \(self.viewModel.balance)")
                    .padding(5)
                    .background(Color.white)

                Text("Quote Balance: \(self.viewModel.quoteBalance)")
                    .padding(5)
                    .background(Color.white)

                Text("Portfolio Balance: \(self.viewModel.portfolioBalance)")
                    .padding(5)
                    .background(Color.white)
            }

            ScrollView {
                LazyVGrid(columns: self.accountBalanceListColumns) {
                    Group {
                        Text("Asset")
                        Text("Free")
                        Text("Locked")
                        Text("Price")
                        Text("Quantity \(Constants.quoteAssetSymbol)")
                        Text("Last Trade Price")
                    }
                    .padding(.bottom, 1)
                    .font(.headline)

                    ForEach(self.viewModel.accountAssetList, id: \.self) { asset in
                        Group {
                            Text("\(asset.name)")
                            Text("\(asset.freeAsString)")
                            Text("\(asset.lockedAsString)")
                            Text("\(asset.priceAsString)")
                            Text("\(asset.quoteQuantityAsString)")
                            Text("\(asset.lastTradePriceAsString)")
                        }
                        .foregroundColor(asset.locked != 0 ? .blue : .black)
                    }
                }
                .padding(5)
                .background(Color.white)
            }

            Spacer()

            HStack {
                Text("Status: \(self.viewModel.tradingEngineStatus)")
                    .padding(5)
                    .background(Color.white)

                Text("Last run date: \(self.viewModel.lastRunDateAsString)")
                    .padding(5)
                    .background(Color.white)
            }

            HStack {
                Text("Error Message: \(self.viewModel.errorMessage)")
                    .padding(5)
                    .background(Color.white)

                Spacer()

                Button("Start") {
                    self.viewModel.startTradingEngine()
                }
            }
        }
        .frame(maxWidth: .infinity,
               maxHeight: .infinity,
               alignment: .topLeading)
        .padding(10)
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
