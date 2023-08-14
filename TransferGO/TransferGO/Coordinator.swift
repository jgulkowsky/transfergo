//
//  Coordinator.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 14/08/2023.
//

import Foundation

protocol Coordinator {
    func goToSelectCountry(_ info: SelectCountryInfo)
    func goToCurrencyConverter(_ info: CurrencyConverterInfo)
}
