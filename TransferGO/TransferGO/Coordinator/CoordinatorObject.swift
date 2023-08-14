//
//  CoordinatorObject.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 14/08/2023.
//

import Foundation

class CoordinatorObject: ObservableObject, Coordinator {
    @Published var currencyConverterViewModel: CurrencyConverterViewModel!
    @Published var selectCountryViewModel: SelectCountryViewModel?
    
    init() {
        self.currencyConverterViewModel = CurrencyConverterViewModel(
            info: CurrencyConverterInfo(
                fromCountry: "Poland", toCountry: "Ukraine", fromAmount: 300
            ),
            coordinator: self)
    }
    
    func goToSelectCountry(_ info: SelectCountryInfo) {
        self.selectCountryViewModel = SelectCountryViewModel(
            info: info, coordinator: self
        )
    }
    
    func goToCurrencyConverter(_ info: CurrencyConverterInfo) {
        if let fromCountry = info.fromCountry {
            self.currencyConverterViewModel.fromCountry = fromCountry
        } else if let toCountry = info.toCountry {
            self.currencyConverterViewModel.toCountry = toCountry
        }
    }
}
