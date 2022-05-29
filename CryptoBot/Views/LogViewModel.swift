//
//  LogViewModel.swift
//  Crypto Bot
//
//  Created by Andre Muis on 5/16/22.
//

import Combine
import Foundation

class LogViewModel: ObservableObject {
    @Published var output: String

    private var subscribers = Set<AnyCancellable>()

    init() {
        self.output = ""

        Logger.shared.$output.sink { output in
            self.output = output
        }
        .store(in: &self.subscribers)
    }
}
