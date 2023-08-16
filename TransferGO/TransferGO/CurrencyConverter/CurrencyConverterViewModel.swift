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
    @Published var fromAmount: String = ""
    @Published var toAmount: Double? // todo: update every time we have change something (user clicks sth) or even with regular frequency with some scheduler (when user doesn't do anything)
    
    @Published var selectedItem: SelectType = .from
    var fromZIndex: Double { (selectedItem == .from) ? 1 : 0 }
    var toZIndex: Double { (selectedItem == .to) ? 1 : 0 }
    
    @Published var fromAmountFocused: Bool = false
    @Published var currentRate: String = "---"
    
    private var coordinator: Coordinator
    
    init(info: CurrencyConverterInfo, coordinator: Coordinator) {
        if let fromCountry = info.fromCountry {
            self.fromCountry = fromCountry
        }
        
        if let toCountry = info.toCountry {
            self.toCountry = toCountry
        }
        
        if let fromAmount = info.fromAmount {
            self.fromAmount = String(format: "%.2f", fromAmount) // maybe we should pass this to be in EditableCurrencyView only?
        }
        
        currentRate = "1 PLN ~ 7.23384 UAH" // todo: later on we need to get it from server
        
        self.coordinator = coordinator
    }
    
    func sendFromTapped() {
        selectedItem = .from
        fromAmountFocused = false
        coordinator.goToSelectCountry(SelectCountryInfo(type: .from))
    }
    
    func sendToTapped() {
        selectedItem = .to
        fromAmountFocused = false
        coordinator.goToSelectCountry(SelectCountryInfo(type: .to))
    }
    
    func switchTapped() {
        (fromCountry, toCountry) = (toCountry, fromCountry)
        fromAmountFocused = false
    }
    
    func amountTapped() {
        selectedItem = .from
    }
}
