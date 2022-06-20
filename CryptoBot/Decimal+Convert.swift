//
//  Decimal+Convert.swift
//  Crypto Bot
//
//  Created by Andre Muis on 5/16/22.
//

import Foundation

extension Decimal {
    var significantFractionDigits: Int {
        return max(-exponent, 0)
    }

    func roundDown(fractionDigits: Int) -> Decimal? {
        let formatter = NumberFormatter()
        formatter.roundingMode = .down
        formatter.maximumFractionDigits = fractionDigits

        if let formattedAsString = formatter.string(for: self) {
            return Decimal(string: formattedAsString)
        } else {
            return nil
        }
    }

    var intValue: Int {
        return NSDecimalNumber(decimal: self).intValue
    }

    var doubleValue: Double {
        return NSDecimalNumber(decimal: self).doubleValue
    }

    var stringValue: String {
        return NSDecimalNumber(decimal: self).stringValue
    }

    var currencyAsString: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        let quantityAsString = formatter.string(for: self)

        return quantityAsString ?? ""
    }
}
