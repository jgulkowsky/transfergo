//
//  Country.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 14/08/2023.
//

import Foundation

// todo: think about changing this struct into Currency - or have two struct where one contains another one like Country that contains Currency
// todo: adjust PredefinedCountry then too

struct Country: Hashable {
    var name: String
    var currency: String
    var code: String
    var flagImage: String
    var limit: Double
}
