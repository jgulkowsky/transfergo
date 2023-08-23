//
//  MockCountriesProvider.swift
//  TransferGOTests
//
//  Created by Jan Gulkowski on 22/08/2023.
//

import Foundation

class MockCountriesProvider: CountriesProviding {
    var shouldThrow: Bool = false
    var countriesToReturn: [Country] = []
    
    func getCountries() async throws -> [Country] {
        if shouldThrow {
            throw MockError.someError
        }
        return countriesToReturn
    }
}
