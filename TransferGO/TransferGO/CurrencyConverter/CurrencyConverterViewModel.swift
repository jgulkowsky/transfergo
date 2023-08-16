//
//  CurrencyConverterViewModel.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 14/08/2023.
//

import Foundation

class CurrencyConverterViewModel: ObservableObject {
    @Published var fromCountry: Country!
    @Published var toCountry: Country!
    @Published var fromAmount: Double!
    @Published var toAmount: Double? = nil // todo: update every time we have change something (user clicks sth) or even with regular frequency with some scheduler (when user doesn't do anything)
    
    @Published var selectedItem: SelectType = .from
    var fromZIndex: Double { (selectedItem == .from) ? 1 : 0 }
    var toZIndex: Double { (selectedItem == .to) ? 1 : 0 }
    
    private var coordinator: Coordinator
    
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
        selectedItem = .from
        coordinator.goToSelectCountry(SelectCountryInfo(type: .from))
    }
    
    func sendToTapped() {
        selectedItem = .to
        coordinator.goToSelectCountry(SelectCountryInfo(type: .to))
    }
    
    func switchTapped() {
        // todo: replace
    }
    
    func amountTapped() {
        // todo: open keyboard
    }
}
