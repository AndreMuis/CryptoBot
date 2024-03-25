//
//  TimeInForce.swift
//  Crypto Bot
//
//  Created by Andre Muis on 11/6/23.
//

import Foundation

enum TimeInForce: String, Decodable {
    case goodTillCancelled = "GTC"
    case immediateOrCancel = "IOC"
    case fillOrKill = "FOK"
}
