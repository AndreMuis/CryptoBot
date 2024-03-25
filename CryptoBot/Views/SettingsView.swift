//
//  SettingsView.swift
//  Crypto Bot
//
//  Created by Andre Muis on 5/16/22.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel = SettingsViewModel()

    var body: some View {
        VStack(alignment: .leading) {
            Text("ByBit US API")
                .bold()
                .padding(5)
                .background(Color.white)

            HStack {
                Text("ByBit US API Key:")

                TextField("ByBit US API key", text: self.$viewModel.byBitAPIKey)
                    .padding(5)
                    .background(Color.white)
            }

            HStack {
                Text("ByBit US Secret Key:")

                TextField("ByBit US secret key", text: self.$viewModel.byBitAPISecret)
                    .padding(5)
                    .background(Color.white)
            }

            Button("Save") {
                self.viewModel.saveByBitAPIValues()
            }
            .padding(.bottom, 20)

            Text("SMTP Server")
                .bold()
                .padding(5)
                .background(Color.white)

            HStack {
                Text("Hostname:")

                TextField("Hostname (e.g. smtp.gmail.com)", text: self.$viewModel.smtpServerHostname)
                    .padding(5)
                    .background(Color.white)
            }
            
            HStack {
                Text("Email:")

                TextField("Email", text: self.$viewModel.smtpServerEmail)
                    .padding(5)
                    .background(Color.white)
            }
            HStack {
                Text("Password:")

                TextField("Password", text: self.$viewModel.smtpServerPassword)
                    .padding(5)
                    .background(Color.white)
            }

            Button("Save") {
                self.viewModel.saveSMTPServerValues()
            }

            Spacer()
        }
        .padding(10)
        .onAppear {
            self.viewModel.viewDidAppear()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
