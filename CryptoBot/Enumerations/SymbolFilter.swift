//
//  SymbolFilter.swift
//  Crypto Bot
//
//  Created by Andre Muis on 5/28/22.
//

import Foundation

enum SymbolFilter: String, Decodable {
    case price = "PRICE_FILTER"
    case pecentPrice = "PERCENT_PRICE"
    case lotSize = "LOT_SIZE"
    case minNotional = "MIN_NOTIONAL"
    case icebergeParts = "ICEBERG_PARTS"
    case marketLotSize = "MARKET_LOT_SIZE"
    case maxNumberOfOrders = "MAX_NUM_ORDERS"
    case maxNumberOfAlgoOrders = "MAX_NUM_ALGO_ORDERS"
    case maxNumberOfIcebergOrders = "MAX_NUM_ICEBERG_ORDERS"
    case maxPosition = "MAX_POSITION"
}
