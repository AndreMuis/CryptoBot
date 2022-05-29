//
//  Endpoint.swift
//  CryptoBot
//
//  Created by Andre Muis on 4/27/22.
//

import Foundation

protocol Endpoint {
    var url: URL { get }
    var httpMethod: String { get }
    var httpHeaderFieldDictionary: [String: String]? { get }

    var request: URLRequest { get }
}

extension Endpoint {
    var request: URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = self.httpMethod

        if let dictionary = self.httpHeaderFieldDictionary {
            for (key, value) in dictionary {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }

        return request
    }
}
