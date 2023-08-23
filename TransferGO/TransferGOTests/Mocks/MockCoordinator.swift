//
//  MockCoordinator.swift
//  TransferGOTests
//
//  Created by Jan Gulkowski on 22/08/2023.
//

import Foundation

class MockCoordinator: Coordinator {
    var wentToSelectCountry: Bool = false
    var infoPassedToSelectCountry: SelectCountryInfo?
    var wentToCurrencyConverter: Bool = false
    var infoPassedToCurrencyConverter: CurrencyConverterInfo?
    
    func goToSelectCountry(_ info: SelectCountryInfo) {
        wentToSelectCountry = true
        infoPassedToSelectCountry = info
    }
    
    func goToCurrencyConverter(_ info: CurrencyConverterInfo) {
        wentToCurrencyConverter = true
        infoPassedToCurrencyConverter = info
    }
}
