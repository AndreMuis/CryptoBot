//
//  FearAndGreedIndex.swift
//  CryptoBot
//
//  Created by Andre Muis on 4/22/22.
//

import Foundation

struct FearAndGreedIndex: Decodable {
    var value: Int
    var valueClassification: String

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.value = try container.integerFromString(codingKey: .value)
        self.valueClassification = try container.decode(String.self, forKey: .valueClassification)
    }

    enum CodingKeys: String, CodingKey {
        case value = "value"
        case valueClassification = "value_classification"
    }
}
