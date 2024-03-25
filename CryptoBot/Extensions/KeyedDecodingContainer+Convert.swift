//
//  KeyedDecodingContainer+Convert.swift
//  Crypto Bot
//
//  Created by Andre Muis on 5/22/22.
//

import Foundation

extension KeyedDecodingContainer {
    func boolFromString(codingKey: K) throws -> Bool {
        let valueAsString = try self.decode(String.self, forKey: codingKey)

        if valueAsString == "0" {
            return false
        } else if valueAsString == "1" {
            return true
        } else {
            throw DecodingError.dataCorruptedError(forKey: codingKey,
                                                   in: self,
                                                   debugDescription: "could not convert String to Decimal")
        }
    }

    func integerFromString(codingKey: K) throws -> Int {
        let valueAsString = try self.decode(String.self, forKey: codingKey)

        if let value = Int(valueAsString) {
            return value
        } else {
            throw DecodingError.dataCorruptedError(forKey: codingKey,
                                                   in: self,
                                                   debugDescription: "could not convert String to Decimal")
        }
    }

    func decimalFromString(codingKey: K) throws -> Decimal {
        let valueAsString = try self.decode(String.self, forKey: codingKey)

        if let value = Decimal(string: valueAsString) {
            return value
        } else {
            throw DecodingError.dataCorruptedError(forKey: codingKey,
                                                   in: self,
                                                   debugDescription: "could not convert String to Decimal")
        }
    }
}
