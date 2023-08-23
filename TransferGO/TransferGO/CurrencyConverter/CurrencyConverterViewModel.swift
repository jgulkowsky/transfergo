//
//  CurrencyConverterViewModel.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 14/08/2023.
//

import Foundation

// todo: on iPad you don't see this on main screen but on this left one
// todo: on the background there should be these 2 tabs too... inactive
// todo: maybe we also should one place with overlays? (eventually parametrize opacity)

class CurrencyConverterViewModel: ObservableObject {
    @Published var fromCountry: Country! {
        willSet {
            if !isBeingAutoSwitched && toCountry == newValue {
                isBeingAutoSwitched = true
                toCountry = fromCountry
            }
        }
        didSet {
            checkLimits()
            tryToUpdateCurrentRate()
            isBeingAutoSwitched = false
        }
    }
    @Published var toCountry: Country! {
        willSet {
            if !isBeingAutoSwitched && fromCountry == newValue {
                isBeingAutoSwitched = true
                fromCountry = toCountry
            }
        }
        didSet {
            tryToUpdateCurrentRate()
            isBeingAutoSwitched = false
        }
    }
    
    @Published var fromAmount: String = "" {
        didSet {
            checkLimits()
            tryToUpdateCurrentRate()
        }
    }
    var toAmount: Double? {
        return currentRate?.toAmount
    }

    @Published var fromAmountFocused: Bool = false
    
    var currentRateText: String {
        currentRate?.toString() ?? "---"
    }
    
    @Published var connectionError: String? = nil {
        didSet {
            if connectionError == nil {
                tryToUpdateCurrentRate()
            }
        }
    }
    @Published var limitExceededError: String? = nil
    @Published var getCurrentRateError: String? = nil
    
    var shouldEnableFields: Bool {
        return connectionError == nil
    }
    
    var limitExceeded: Bool {
        return limitExceededError != nil
    }
    
    private let coordinator: Coordinator
    private let rateProvider: RateProviding
    private let scheduler: Scheduling
    private let networkStatusProvider: NetworkStatusProviding
    
    private var getCurrentRateTask: Task<(), Never>? = nil
    private var currentRate: Rate? = nil
    private var isBeingAutoSwitched = false
    
    init(info: CurrencyConverterInfo,
         coordinator: Coordinator,
         rateProvider: RateProviding,
         scheduler: Scheduling,
         networkStatusProvider: NetworkStatusProviding) {
        if let fromCountry = info.fromCountry {
            self.fromCountry = fromCountry
        }
        
        if let toCountry = info.toCountry {
            self.toCountry = toCountry
        }
        
        if let fromAmount = info.fromAmount {
            self.fromAmount = fromAmount.limitDecimalPlaces(to: 2)
        }
        
        self.coordinator = coordinator
        self.rateProvider = rateProvider
        self.scheduler = scheduler
        self.networkStatusProvider = networkStatusProvider
        
        tryToUpdateCurrentRate()
    }
    
    func onSceneActive() {
        startRegularCurrentRateUpdates()
        startGettingNetworkStatus()
    }
    
    func onSceneInactive() {
        stopRegularCurrentRateUpdates()
        stopGettingNetworkStatus()
    }
    
    func onSceneInBackground() {
        stopRegularCurrentRateUpdates()
        stopGettingNetworkStatus()
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
        tryToUpdateCurrentRate()
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
            limitExceededError = "Maximum sending amount \(fromCountry.currencyLimit.limitDecimalPlaces(to: 2)) \(fromCountry.currencyCode)"
        } else {
            limitExceededError = nil
        }
    }
    
    func tryToUpdateCurrentRate(shouldResetCurrentValues: Bool = true) {
        getCurrentRateTask?.cancel()
        if shouldResetCurrentValues {
            currentRate = nil
            getCurrentRateError = nil
        }
        if areRequirementsForGettingCurrentRateSatisfied() {
            getCurrentRate()
        }
    }
    
    func startRegularCurrentRateUpdates() {
        self.scheduler.start { [weak self] in
            self?.tryToUpdateCurrentRate(shouldResetCurrentValues: false)
        }
    }
    
    func stopRegularCurrentRateUpdates() {
        self.scheduler.stop()
    }
    
    func areRequirementsForGettingCurrentRateSatisfied() -> Bool {
        return Double(fromAmount) != nil && !fromAmountFocused && !limitExceeded
    }
    
    func getCurrentRate() {
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
                    getCurrentRateError = nil
                }
            }
            catch URLError.cancelled {}
            catch (let error) where error is CancellationError {}
            catch {
                await MainActor.run {
                    getCurrentRateError = "Cannot get current rate for \(fromCountry.currencyCode) ~ \(toCountry.currencyCode)"
                    currentRate = nil
                }
            }
        }
    }
    
    func startGettingNetworkStatus() {
        networkStatusProvider.start { [weak self] isConnected in
            if isConnected {
                self?.connectionError = nil
            } else {
                self?.connectionError = "No internet connection"
            }
        }
    }
    
    func stopGettingNetworkStatus() {
        networkStatusProvider.stop()
    }
}
