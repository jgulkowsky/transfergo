//
//  CurrencyConverterViewModel.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 14/08/2023.
//

import Foundation

// todo: we should lock possibility to select same from and to country - there should not be current in SelectCountryViewModel list of countries

// todo: maybe we also should one place with overlays? (eventually parametrize opacity)

// todo: we should rather not to resetCurrentRateAndToAmount() when we go to SelectCountryView (only when we actuall change it)

// todo: there's also a bug when user types in out of limit value (then no rate is shown) and then he clicks on switch button and even the value is still out of limit the rate is downloaded (and should behave as earlier) - this probably applies to taps on other things that trigger getting rate - also check it for scenario when value is out of limit for the first currency but after switch it's not out of limit for another one - then you should call for rate

class CurrencyConverterViewModel: ObservableObject {
    @Published var fromCountry: Country! {
        didSet {
            checkLimits()
            getCurrentRateAndToAmount()
        }
    }
    @Published var toCountry: Country! {
        didSet {
            getCurrentRateAndToAmount()
        }
    }
    @Published var fromAmount: String = "" {
        didSet {
            checkLimits()
            getCurrentRateTask?.cancel()
            resetCurrentRateAndToAmount()
        }
    }
    @Published var toAmount: Double?
    
    @Published var fromAmountFocused: Bool = false {
        didSet {
            guard !fromAmountFocused
                    && !fromAmount.isEmpty
                    && !limitExceeded else {
                return
            }
            getCurrentRateAndToAmount()
        }
    }
    
    @Published var currentRate: Rate? = nil
    var currentRateText: String {
        currentRate?.toString() ?? "---"
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
    
    private var getCurrentRateTask: Task<(), Never>? = nil
    
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
        
        getCurrentRateAndToAmount()
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
        getCurrentRateAndToAmount()
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
    
    func getCurrentRateAndToAmount() {
        guard let amount = Double(fromAmount) else {
            return
        }
        
        getCurrentRateTask?.cancel()
        
        getCurrentRateTask = Task {
            do {
                await MainActor.run {
                    resetCurrentRateAndToAmount()
                }
                let rate = try await rateProvider.getRate(
                    from: fromCountry,
                    to: toCountry,
                    amount: amount
                )
                await MainActor.run {
                    currentRate = rate
                    toAmount = rate.toAmount // todo: do we need this? can't we just use currentRate.toAmount in the View?
                }
            } catch {
                // todo: handle error - first of all currentRateText should be ---
                // todo: secondly we should show some popup or use our errorText to tell that sth went wrong
            }
        }
        // todo: btw we should regularly check the rate e.g. every 10 seconds and also when user does sth
    }
    
    func resetCurrentRateAndToAmount() {
        currentRate = nil
        toAmount = nil
    }
}
