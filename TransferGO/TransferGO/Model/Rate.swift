//
//  Rate.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 18/08/2023.
//

import Foundation

struct Rate: Decodable {
    var from: String
    var to: String
    var rate: Double
    var fromAmount: Double
    var toAmount: Double
    
    func toString() -> String {
        return "1 \(from) ~ \(rate.limitDecimalPlaces(to: 5)) \(to)"
    }
}
