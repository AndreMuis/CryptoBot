//
//  TimeInForce.swift
//  Crypto Bot
//
//  Created by Andre Muis on 5/21/22.
//

import Foundation

enum TimeInForce: String, Decodable {
    case goodTillCancelled = "GTC"
    case immediateOrCancel = "IOC"
    case fillOrKill = "FOK"
}
