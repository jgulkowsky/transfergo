//
//  CountriesProvider.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 18/08/2023.
//

import Foundation

class CountriesProvider: CountriesProviding {
    func getCountries() async throws -> [Country] {
        return [
            PredefinedCountry.poland,
            PredefinedCountry.germany,
            PredefinedCountry.greatBritain,
            PredefinedCountry.ukraine
        ]
    }
}
