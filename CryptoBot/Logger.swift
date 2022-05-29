//
//  Logger.swift
//  Crypto Bot
//
//  Created by Andre Muis on 5/16/22.
//

import Foundation

class Logger: ObservableObject {
    @Published var output: String = ""

    static let shared = Logger()

    func add(entry: String) {
        let formattedDate = Date().formatted(date: .abbreviated, time: .shortened)
        var entry = "[\(formattedDate)] \(entry)"

        if !self.output.isEmpty {
            entry = "\n\n\(entry)"
        }

        self.output.append(entry)
    }
}
