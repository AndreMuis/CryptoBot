//
//  URLSession+DataTaskPublisher.swift
//  Crypto Bot
//
//  Created by Andre Muis on 5/8/22.
//

import Combine
import Foundation

extension URLSession {
    static func dataTaskPublisher(for endpoint: Endpoint) -> AnyPublisher<Data, URLError> {
        let publisher = URLSession.shared.dataTaskPublisher(for: endpoint.request)
            .receive(on: DispatchQueue.main)
            .map { $0.data }
            .eraseToAnyPublisher()

        return publisher
    }
}

