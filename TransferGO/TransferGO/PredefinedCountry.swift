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
        flagImageAssetName: "Poland",
        currency: "Polish Zloty",
        currencyCode: "PLN",
        currencyLimit: 20000
    )
    
    static let ukraine = Country(
        name: "Ukraine",
        flagImageAssetName: "Ukraine",
        currency: "Hrivna",
        currencyCode: "UAH",
        currencyLimit: 50000
    )
    
    static let germany = Country(
        name: "Germany",
        flagImageAssetName: "Germany",
        currency: "Euro",
        currencyCode: "EUR",
        currencyLimit: 5000
    )
    
    static let greatBritain = Country(
        name: "Great Britain",
        flagImageAssetName: "Great Britain",
        currency: "British Pound",
        currencyCode: "GBP",
        currencyLimit: 1000
    )
}
