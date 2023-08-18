//
//  CountryProvider.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 18/08/2023.
//

import Foundation

class CountriesProvider: CountriesProviding {
    private let backgroundActor = BackgroundActor()
    private var cache: [Country]? = nil // todo: cache is nice but if sth changes on the server side - e.g. limit for transaction in given currency / some countries are added or removed - we should update it
    
    func getCountries() async throws -> [Country] {
        if cache == nil {
            cache = try await backgroundActor.getCountries()
        }
        return cache!
    }
}

extension CountriesProvider {
    actor BackgroundActor {
        func getCountries() async throws -> [Country] {
            try await Task.sleep(nanoseconds: 1_000_000_000)

            return [
                PredefinedCountry.poland,
                PredefinedCountry.germany,
                PredefinedCountry.greatBritain,
                PredefinedCountry.ukraine
            ]
        }
    }
}
