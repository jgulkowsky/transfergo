//
//  Country.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 14/08/2023.
//

import Foundation

struct Country: Hashable {
    var name: String
    var flagImageAssetName: String
    var currency: String
    var currencyCode: String
    var currencyLimit: Double
}
