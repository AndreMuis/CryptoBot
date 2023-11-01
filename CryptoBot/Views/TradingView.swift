//
//  TradingView.swift
//  Crypto Bot
//
//  Created by Andre Muis on 10/31/23.
//

import SwiftUI

struct TradingView: View {
    @ObservedObject private var viewModel: TradingViewModel

    init(userAccount: UserAccount) {
        self.viewModel = TradingViewModel(userAccount: userAccount)
    }

    var body: some View {
        VStack {
            Button("Buy Assets") {
                self.viewModel.buyAssets()
            }
        }
        .frame(maxWidth: .infinity,
               maxHeight: .infinity)
        .alert("", isPresented: self.$viewModel.isAlertPresented) {
            Button("Cancel") {
                self.viewModel.isAlertPresented = false
            }

            Button("OK") {
                self.viewModel.buyAsset()
            }
        } message: {
            Text(self.viewModel.alertMessage)
        }
    }
}

struct TradingView_Previews: PreviewProvider {
    static var previews: some View {
        TradingView(userAccount: UserAccount())
    }
}
