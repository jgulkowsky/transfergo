//
//  CurrencyConverterViewModel.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 14/08/2023.
//

import Foundation

// todo: we should have one place where we change amount into String(format: "%.2f", amount)

class CurrencyConverterViewModel: ObservableObject {
    @Published var fromCountry: Country! {
        didSet {
            checkLimits()
        }
    }
    @Published var toCountry: Country!
    @Published var fromAmount: String = "" {
        didSet {
            checkLimits()
        }
    }
    @Published var toAmount: Double? // todo: update every time we have change something (user clicks sth) or even with regular frequency with some scheduler (when user doesn't do anything)
    
    @Published var fromAmountFocused: Bool = false
    @Published var currentRate: String = "---"
    
    @Published var connectionError: String? = nil
    @Published var limitExceededError: String? = nil
    
    var shouldEnableFields: Bool {
        return connectionError == nil
    }
    
    var limitExceeded: Bool {
        return limitExceededError != nil
    }
    
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
        
        // todo: check connection - show error if problems
//        connectionError = "No internet connection"
        
        self.coordinator = coordinator
    }
    
    func sendFromTapped() {
//        selectedItem = .from
        fromAmountFocused = false
        coordinator.goToSelectCountry(SelectCountryInfo(type: .from))
    }
    
    func sendToTapped() {
//        selectedItem = .to
        fromAmountFocused = false
        coordinator.goToSelectCountry(SelectCountryInfo(type: .to))
    }
    
    func switchTapped() {
        (fromCountry, toCountry) = (toCountry, fromCountry)
        fromAmountFocused = false
        checkLimits()
    }
    
    func amountTapped() {
//        selectedItem = .from
    }
}

private extension CurrencyConverterViewModel {
    func checkLimits() {
        if let amount = Double(fromAmount),
           amount > fromCountry.limit {
            limitExceededError = "Maximum sending amount \(String(format: "%.2f", fromCountry.limit)) \(fromCountry.code)"
        } else {
            limitExceededError = nil
        }
    }
}
