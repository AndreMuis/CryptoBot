//
//  SettingsViewModel.swift
//  Crypto Bot
//
//  Created by Andre Muis on 5/29/22.
//

import Combine
import Foundation
import AppKit

class SettingsViewModel: ObservableObject {
    @Published var binanceUSAPIKey: String = ""
    @Published var binanceUSAPISecretKey: String = ""

    @Published var smtpServerHostname: String = ""
    @Published var smtpServerEmail: String = ""
    @Published var smtpServerPassword: String = ""

    func viewDidAppear() {
        self.smtpServerHostname = AppDefaults.shared.smtpServerHostname ?? ""
        self.smtpServerEmail = AppDefaults.shared.smtpServerEmail ?? ""
        self.smtpServerPassword = AppDefaults.shared.smtpServerPassword ?? ""
    }

    func saveBinanceUSAPIValues() {
        AppDefaults.shared.binanceUSAPIKey = self.binanceUSAPIKey
        AppDefaults.shared.binanceUSAPISecretKey = self.binanceUSAPISecretKey

        self.binanceUSAPIKey = ""
        self.binanceUSAPISecretKey = ""
    }

    func saveSMTPServerValues() {
        AppDefaults.shared.smtpServerHostname = self.smtpServerHostname
        AppDefaults.shared.smtpServerEmail = self.smtpServerEmail
        AppDefaults.shared.smtpServerPassword = self.smtpServerPassword
    }
}
