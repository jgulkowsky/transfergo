//
//  CountriesProvider.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 18/08/2023.
//

import Foundation

class CountriesProvider: CountriesProviding {
    private let backgroundActor = BackgroundActor()
    private var cache: [Country]? = nil // todo: cache is nice but if sth changes on the server side - e.g. limit for transaction in given currency / some countries are added or removed - we should update it
    private var prefetchTask: Task<(), Never>? = nil
    
    init() {
        prefetchCountries()
    }
    
    func getCountries() async throws -> [Country] {
        prefetchTask?.cancel()
        return try await getCountriesWithoutCancellingPrefetchTask()
    }
}

private extension CountriesProvider {
    actor BackgroundActor {
        func getCountries() async throws -> [Country] {
            try await Task.sleep(nanoseconds: 2_000_000_000) // todo: for now the only place that can throw is Task.sleep but you rather should be prepared for situation where your call for countries ends up with failure

            return [
                PredefinedCountry.poland,
                PredefinedCountry.germany,
                PredefinedCountry.greatBritain,
                PredefinedCountry.ukraine
            ]
        }
    }
    
    func prefetchCountries() {
        prefetchTask = Task {
            _ = try? await getCountriesWithoutCancellingPrefetchTask()
        }
    }
    
    func getCountriesWithoutCancellingPrefetchTask() async throws -> [Country] {
        if cache == nil {
            cache = try await backgroundActor.getCountries()
        }
        return cache!
    }
}

