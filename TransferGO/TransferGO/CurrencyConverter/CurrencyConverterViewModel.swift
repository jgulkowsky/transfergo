//
//  CurrencyConverterViewModel.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 14/08/2023.
//

import Foundation

class CurrencyConverterViewModel: ObservableObject {
    var coordinator: Coordinator
    @Published var fromCountry: Country!
    @Published var toCountry: Country!
    @Published var fromAmount: Int!
    
    init(info: CurrencyConverterInfo, coordinator: Coordinator) {
        if let fromCountry = info.fromCountry {
            self.fromCountry = fromCountry
        }
        
        if let toCountry = info.toCountry {
            self.toCountry = toCountry
        }
        
        if let fromAmount = info.fromAmount {
            self.fromAmount = fromAmount
        }
        
        self.coordinator = coordinator
    }
    
    func sendFromTapped() {
        // todo: move to front if needed
        coordinator.goToSelectCountry(SelectCountryInfo(type: .from))
    }
    
    func sendToTapped() {
        // todo: move to front if needed
        coordinator.goToSelectCountry(SelectCountryInfo(type: .to))
    }
    
    func switchTapped() {
        // todo: replace
    }
    
    func amountTapped() {
        // todo: open keyboard
    }
}
