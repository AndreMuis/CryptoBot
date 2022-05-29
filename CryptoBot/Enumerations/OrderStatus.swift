//
//  OrderStatus.swift
//  CryptoBot
//
//  Created by Andre Muis on 4/25/22.
//

import Foundation

enum OrderStatus: String, Decodable {
    case new = "NEW"
    case partiallyFilled = "PARTIALLY_FILLED"
    case filled = "FILLED"
    case cancelled = "CANCELED"
    case pendingCancel = "PENDING_CANCEL"
    case rejected = "REJECTED"
    case expired = "EXPIRED"
}
