//
//  MockCoordinator.swift
//  TransferGOTests
//
//  Created by Jan Gulkowski on 22/08/2023.
//

import Foundation

class MockCoordinator: Coordinator {
    var wentToSelectCountry: Bool = false
    var wentToCurrencyConverter: Bool = false
    
    func goToSelectCountry(_ info: SelectCountryInfo) {
        wentToSelectCountry = true
    }
    
    func goToCurrencyConverter(_ info: CurrencyConverterInfo) {
        wentToCurrencyConverter = true
    }
}
