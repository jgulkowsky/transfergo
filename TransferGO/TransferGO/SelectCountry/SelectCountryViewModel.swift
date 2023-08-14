//
//  SelectCountryViewModel.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 14/08/2023.
//

import Foundation

class SelectCountryViewModel: ObservableObject, Identifiable {
    @Published var countries: [Country] = []
    
    var coordinator: Coordinator
    var type: SelectType
    
    private var allCountries: [Country] = []
    
    init(info: SelectCountryInfo, coordinator: Coordinator) {
        self.type = info.type
        self.coordinator = coordinator
        getAllCountries()
        updateCountries()
    }
    
    func getAllCountries() {
        // todo: add service that will return them with aync method
        self.allCountries = [
            Country(name: "Poland", currency: "Polish Zloty", code: "PLN"),
            Country(name: "Germany", currency: "Euro", code: "EUR"),
            Country(name: "Great Britain", currency: "British Pound", code: "GBP"),
            Country(name: "Ukraine", currency: "Hrivna", code: "UAH")
        ]
    }
    
    func updateCountries() {
        // todo: take typed word into account to filter out all countries
        self.countries = self.allCountries
    }
    
    func onCountryTapped(_ country: Country) {
        coordinator.goToCurrencyConverter(
            (type == .from)
                ? CurrencyConverterInfo(fromCountry: country)
                : CurrencyConverterInfo(toCountry: country)
        )
    }
}
