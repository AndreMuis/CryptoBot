//
//  Decimal+Convert.swift
//  Crypto Bot
//
//  Created by Andre Muis on 5/16/22.
//

import Foundation

extension Decimal {
    var stringValue: String {
        return NSDecimalNumber(decimal: self).stringValue
    }

    var currencyAsString: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        let quantityAsString = formatter.string(for: self)

        return quantityAsString ?? ""
    }

    func getStringValue(maximumFractionDigits: Int) -> String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = maximumFractionDigits

        return formatter.string(for: self) ?? ""
    }
}
