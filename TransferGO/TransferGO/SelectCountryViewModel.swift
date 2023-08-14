//
//  SelectCountryViewModel.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 14/08/2023.
//

import Foundation

class SelectCountryViewModel: ObservableObject, Identifiable {
    var coordinator: Coordinator
    var type: SelectType
    
    init(info: SelectCountryInfo, coordinator: Coordinator) {
        self.type = info.type
        self.coordinator = coordinator
    }
    
    func onCountryTapped(_ country: String) {
        coordinator.goToCurrencyConverter(
            (type == .from)
                ? CurrencyConverterInfo(fromCountry: country)
                : CurrencyConverterInfo(toCountry: country)
        )
    }
}
