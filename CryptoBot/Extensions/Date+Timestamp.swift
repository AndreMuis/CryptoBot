//
//  Date+Timestamp.swift
//  Crypto Bot
//
//  Created by Andre Muis on 5/1/22.
//

import Foundation

extension Date {
    static var timestamp: Int {
        Int(Date().timeIntervalSince1970 * 1000)
    }
}
