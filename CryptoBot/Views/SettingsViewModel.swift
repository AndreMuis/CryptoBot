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
    @Published var byBitAPIKey: String = ""
    @Published var byBitAPISecret: String = ""

    @Published var smtpServerHostname: String = ""
    @Published var smtpServerEmail: String = ""
    @Published var smtpServerPassword: String = ""

    func viewDidAppear() {
        self.byBitAPIKey = AppDefaults.shared.byBitAPIKey ?? ""
        self.byBitAPISecret = AppDefaults.shared.byBitAPISecret ?? ""

        self.smtpServerHostname = AppDefaults.shared.smtpServerHostname ?? ""
        self.smtpServerEmail = AppDefaults.shared.smtpServerEmail ?? ""
        self.smtpServerPassword = AppDefaults.shared.smtpServerPassword ?? ""
    }

    func saveByBitAPIValues() {
        AppDefaults.shared.byBitAPIKey = self.byBitAPIKey
        AppDefaults.shared.byBitAPISecret = self.byBitAPISecret
    }

    func saveSMTPServerValues() {
        AppDefaults.shared.smtpServerHostname = self.smtpServerHostname
        AppDefaults.shared.smtpServerEmail = self.smtpServerEmail
        AppDefaults.shared.smtpServerPassword = self.smtpServerPassword
    }
}
