//
//  CurrencyConverterViewModel.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 14/08/2023.
//

import Foundation

// todo: maybe we also should one place with overlays? (eventually parametrize opacity)

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
    var currentRate: String {
        "1 \(fromCountry.currencyCode) ~ 7.23384 \(toCountry.currencyCode)" // todo: later on we need to get it from server
        // todo: when there's no rate we should use "---"
    }
    
    @Published var connectionError: String? = nil
    @Published var limitExceededError: String? = nil
    
    var shouldEnableFields: Bool {
        return connectionError == nil
    }
    
    var limitExceeded: Bool {
        return limitExceededError != nil
    }
    
    private let coordinator: Coordinator
    private let rateProvider: RateProviding
    
    init(info: CurrencyConverterInfo,
         coordinator: Coordinator,
         rateProvider: RateProviding) {
        if let fromCountry = info.fromCountry {
            self.fromCountry = fromCountry
        }
        
        if let toCountry = info.toCountry {
            self.toCountry = toCountry
        }
        
        if let fromAmount = info.fromAmount {
            self.fromAmount = fromAmount.to2DecPlaces() // todo: maybe we should pass this to be in EditableCurrencyView only?
        }
        
        self.coordinator = coordinator
        self.rateProvider = rateProvider
        
        // todo: check connection - show error if problems
//        connectionError = "No internet connection"
    }
    
    func sendFromTapped() {
        fromAmountFocused = false
        coordinator.goToSelectCountry(SelectCountryInfo(type: .from))
    }
    
    func sendToTapped() {
        fromAmountFocused = false
        coordinator.goToSelectCountry(SelectCountryInfo(type: .to))
    }
    
    func switchTapped() {
        (fromCountry, toCountry) = (toCountry, fromCountry)
        fromAmountFocused = false
        checkLimits()
    }
    
    func backgroundTapped() {
        fromAmountFocused = false
    }
    
    func amountTapped() {}
    
    func requestTapped() {}
    
    func sendTapped() {}
    
    func menuTapped() {}
    
    func bellTapped() {}
}

private extension CurrencyConverterViewModel {
    func checkLimits() {
        if let amount = Double(fromAmount),
           amount > fromCountry.currencyLimit {
            limitExceededError = "Maximum sending amount \(fromCountry.currencyLimit.to2DecPlaces()) \(fromCountry.currencyCode)"
        } else {
            limitExceededError = nil
        }
    }
}
