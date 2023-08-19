//
//  CurrencyConverterViewModel.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 14/08/2023.
//

import Foundation

// todo: we should lock possibility to select same from and to country - there should not be current in SelectCountryViewModel list of countries

// todo: maybe we also should one place with overlays? (eventually parametrize opacity)

class CurrencyConverterViewModel: ObservableObject {
    @Published var fromCountry: Country! {
        didSet {
            checkLimits()
            tryGetCurrentRateAndToAmount()
        }
    }
    @Published var toCountry: Country! {
        didSet {
            tryGetCurrentRateAndToAmount()
        }
    }
    @Published var fromAmount: String = "" {
        didSet {
            checkLimits()
            tryGetCurrentRateAndToAmount()
        }
    }
    @Published var toAmount: Double?
    
    @Published var fromAmountFocused: Bool = false
    
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
        
        tryGetCurrentRateAndToAmount()
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
        tryGetCurrentRateAndToAmount()
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
    
    func tryGetCurrentRateAndToAmount() {
        // todo: it would be also nice to return rate and toAmount immediately if nothing has changed after reset - on the other hand the rate could change in meantime so maybe we should leave it as it is - or add timer that checks how old is our current value - if we have scheduler that gets the values on the background then this still will be updated
        getCurrentRateTask?.cancel()
        
        resetCurrentRateAndToAmount()
        
        guard areRequirementsSatisfied() else {
            return
        }
        
        getCurrentRateAndToAmount()
    }
    
    func resetCurrentRateAndToAmount() {
        currentRate = nil
        toAmount = nil
    }
    
    func areRequirementsSatisfied() -> Bool {
        return Double(fromAmount) != nil && !fromAmountFocused && !limitExceeded
    }
    
    func getCurrentRateAndToAmount() {
        guard let amount = Double(fromAmount) else {
            return
        }
        
        getCurrentRateTask = Task {
            do {
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
}
