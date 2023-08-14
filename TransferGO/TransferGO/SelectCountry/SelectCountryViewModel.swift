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
    
    var coordinator: Coordinator
    private var type: SelectType
    
    private var allCountries: [Country] = []
    
    init(info: SelectCountryInfo, coordinator: Coordinator) {
        self.coordinator = coordinator
        type = info.type
        title = (type == .from) ? "Sending from" : "Sending to"
        getAllCountries()
        updateCountries()

        // todo: bind to typedText so everytime we change it we call updateCountries
    }
    
    func getAllCountries() {
        // todo: add service that will return them with aync method
        self.allCountries = [
            PredefinedCountry.poland,
            PredefinedCountry.germany,
            PredefinedCountry.greatBritain,
            PredefinedCountry.ukraine
        ]
    }
    
    func updateCountries() {
        self.countries = self.allCountries.filter {
            $0.name.starts(with: searchText)
            // todo: you should also consider option of typing currency or code
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
