//
//  AppDefaults.swift
//  Crypto Bot
//
//  Created by Andre Muis on 5/29/22.
//

import Foundation
import AppKit

struct AppDefaults {
    private let userDefaults = NSUserDefaultsController.shared.defaults

    static var shared = AppDefaults()

    var binanceUSAPIKey: String? {
        get {
            userDefaults.string(forKey: Constants.binanceUSAPIKeyKey)
        }

        set {
            userDefaults.set(newValue, forKey: Constants.binanceUSAPIKeyKey)
        }
    }

    var binanceUSAPISecretKey: String? {
        get {
            userDefaults.string(forKey: Constants.binanceUSAPISecretKeyKey)
        }

        set {
            userDefaults.set(newValue, forKey: Constants.binanceUSAPISecretKeyKey)
        }
    }

    var smtpServerHostname: String? {
        get {
            userDefaults.string(forKey: Constants.smtpServerHostnameKey)
        }

        set {
            userDefaults.set(newValue, forKey: Constants.smtpServerHostnameKey)
        }
    }

    var smtpServerEmail: String? {
        get {
            userDefaults.string(forKey: Constants.smtpServerEmailKey)
        }

        set {
            userDefaults.set(newValue, forKey: Constants.smtpServerEmailKey)
        }
    }

    var smtpServerPassword: String? {
        get {
            userDefaults.string(forKey: Constants.smtpServerPasswordKey)
        }

        set {
            userDefaults.set(newValue, forKey: Constants.smtpServerPasswordKey)
        }
    }
}
