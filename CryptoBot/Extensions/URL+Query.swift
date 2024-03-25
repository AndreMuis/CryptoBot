//
//  URL+Query.swift
//  CryptoBot
//
//  Created by Andre Muis on 4/27/22.
//

import Foundation

extension URL {
    mutating func add(queryItems: [URLQueryItem]) throws {
        guard var components = URLComponents(string: self.absoluteString) else {
            throw AppError.genericError(message: "could not extract components from URL")
        }

        components.queryItems = queryItems

        guard let url = components.url else {
            throw AppError.genericError(message: "could not create URL from components")
        }

        self = url
    }
}
