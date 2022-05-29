//
//  LogsView.swift
//  Crypto Bot
//
//  Created by Andre Muis on 5/16/22.
//

import SwiftUI

struct LogView: View {
    @ObservedObject private var viewModel = LogViewModel()

    var body: some View {
        VStack() {
            ScrollView {
                Text(self.viewModel.output)
                    .frame(maxWidth: .infinity)
                    .padding(5)
                    .background(Color.white)
            }.frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity,
               maxHeight: .infinity,
               alignment: .topLeading)
        .padding(10)
    }
}

struct LogView_Previews: PreviewProvider {
    static var previews: some View {
        LogView()
    }
}
