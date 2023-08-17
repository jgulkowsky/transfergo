//
//  PredefinedCountry.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 14/08/2023.
//

import Foundation

struct PredefinedCountry {
    static let poland = Country(
        name: "Poland",
        currency: "Polish Zloty",
        code: "PLN",
        flagImage: "Poland",
        limit: 20000
    )
    
    static let ukraine = Country(
        name: "Ukraine",
        currency: "Hrivna",
        code: "UAH",
        flagImage: "Ukraine",
        limit: 50000
    )
    
    static let germany = Country(
        name: "Germany",
        currency: "Euro",
        code: "EUR",
        flagImage: "Germany",
        limit: 5000
    )
    
    static let greatBritain = Country(
        name: "Great Britain",
        currency: "British Pound",
        code: "GBP",
        flagImage: "Great Britain",
        limit: 1000
    )
}
