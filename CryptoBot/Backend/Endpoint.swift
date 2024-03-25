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
    var httpHeaderFields: [String: String]? { get }
    var httpPOSTFields: [String: String]? { get }

    func createRequest() throws -> URLRequest
}

extension Endpoint {
    func createRequest() throws -> URLRequest  {
        var request = URLRequest(url: url)
        request.httpMethod = self.httpMethod
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let fields = self.httpHeaderFields {
            for (key, value) in fields {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }

        if let fields = self.httpPOSTFields {
            request.httpBody = try JSONSerialization.data(withJSONObject: fields)
        }

        return request
    }
}
