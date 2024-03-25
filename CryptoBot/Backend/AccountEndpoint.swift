//
//  AccountEndpoint.swift
//  CryptoBot
//
//  Created by Andre Muis on 4/28/22.
//

import Foundation

struct AccountEndpoint: Endpoint {
    let url: URL
    let httpMethod: String
    let httpHeaderFields: [String : String]?
    let httpPOSTFields: [String : String]?

    private let shell = Shell()

    init() throws {
        let timestampAsString = String(Date.timestamp)

        guard let byBitAPIKey = AppDefaults.shared.byBitAPIKey else {
            throw AppError.genericError(message: "could not retrieve ByBit API key from app defaults")
        }

        var url = try AppConfiguration.getURL(for: .byBitAccountURLKey)

        let queryItems = [
            URLQueryItem(name: Constants.APIQueryItemNames.accountType, 
                         value: AccountType.unified.rawValue)
        ]

        try url.add(queryItems: queryItems)

        guard let query = url.query else {
            throw AppError.genericError(message: "unable to parse query string from URL")
        }

        let text = "\(timestampAsString)\(byBitAPIKey)\(query)"
        let signature = try self.shell.getSignature(text: text)

        self.url = url
        self.httpMethod = "GET"

        self.httpHeaderFields = [
            Constants.APIHeaderKeys.byBitKey: byBitAPIKey,
            Constants.APIHeaderKeys.timestamp: timestampAsString,
            Constants.APIHeaderKeys.signature: signature]

        self.httpPOSTFields = nil
    }
}
