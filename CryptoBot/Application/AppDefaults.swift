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

    var byBitAPIKey: String? {
        get {
            userDefaults.string(forKey: Constants.AppDefaultKeys.byBitAPIKey)
        }

        set {
            userDefaults.set(newValue, forKey: Constants.AppDefaultKeys.byBitAPIKey)
        }
    }

    var byBitAPISecret: String? {
        get {
            userDefaults.string(forKey: Constants.AppDefaultKeys.byBitAPISecret)
        }

        set {
            userDefaults.set(newValue, forKey: Constants.AppDefaultKeys.byBitAPISecret)
        }
    }

    var smtpServerHostname: String? {
        get {
            userDefaults.string(forKey: Constants.AppDefaultKeys.smtpServerHostname)
        }

        set {
            userDefaults.set(newValue, forKey: Constants.AppDefaultKeys.smtpServerHostname)
        }
    }

    var smtpServerEmail: String? {
        get {
            userDefaults.string(forKey: Constants.AppDefaultKeys.smtpServerEmail)
        }

        set {
            userDefaults.set(newValue, forKey: Constants.AppDefaultKeys.smtpServerEmail)
        }
    }

    var smtpServerPassword: String? {
        get {
            userDefaults.string(forKey: Constants.AppDefaultKeys.smtpServerPassword)
        }

        set {
            userDefaults.set(newValue, forKey: Constants.AppDefaultKeys.smtpServerPassword)
        }
    }
}
