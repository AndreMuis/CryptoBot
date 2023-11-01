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
        ScrollView {
            HStack {
                Text(self.viewModel.output)
                Spacer()
            }
            .padding(5)
        }
        .background(Color.white)
        .padding(10)
    }
}

struct LogView_Previews: PreviewProvider {
    static var previews: some View {
        LogView()
    }
}
