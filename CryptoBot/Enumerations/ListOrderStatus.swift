//
//  ListOrderStatus.swift
//  Crypto Bot
//
//  Created by Andre Muis on 5/22/22.
//

import Foundation

enum ListOrderStatus: String, Decodable {
    case executing = "EXECUTING"
    case allDone = "ALL_DONE"
    case reject = "REJECT"
}
