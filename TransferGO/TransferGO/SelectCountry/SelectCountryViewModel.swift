//
//  SelectCountryViewModel.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 14/08/2023.
//

import Foundation
import SwiftUI

class SelectCountryViewModel: ObservableObject, Identifiable {
    @Published var title: String
    @Published var searchText: String = "" {
        didSet {
            updateCountries()
        }
    }
    @Published var countries: [Country] = []
    @Published var showLoadingIndicator: Bool = false
    @Published var showError: Bool = false
    @Published var showList: Bool = false
    
    private var type: SelectType
    
    private var allCountries: [Country] = []
    
    private let coordinator: Coordinator
    private let countriesProvider: CountriesProviding
    
    init(info: SelectCountryInfo,
         coordinator: Coordinator,
         countriesProvider: CountriesProviding) {
        self.coordinator = coordinator
        self.countriesProvider = countriesProvider
        type = info.type
        title = (type == .from) ? "Sending from" : "Sending to"
    }
    
    func getAllCountries() async {
        do {
            await MainActor.run {
                showError = false
                showLoadingIndicator = true
                showList = false
            }
            
            allCountries = try await countriesProvider.getCountries()
            
            await MainActor.run {
                updateCountries()
                showLoadingIndicator = false
                showList = true
            }
        }
        catch URLError.cancelled {}
        catch (let error) where error is CancellationError {}
        catch {
            await MainActor.run {
                showLoadingIndicator = false
                showError = true
            }
        }
    }
    
    func onCountryTapped(_ country: Country) {
        coordinator.goToCurrencyConverter(
            (type == .from)
                ? CurrencyConverterInfo(fromCountry: country)
                : CurrencyConverterInfo(toCountry: country)
        )
    }
}

private extension SelectCountryViewModel {
    func updateCountries() {
        self.countries = self.allCountries.filter {
            $0.name.starts(with: searchText)
            // todo: you should also consider option of typing currency or code
        }
    }
}
