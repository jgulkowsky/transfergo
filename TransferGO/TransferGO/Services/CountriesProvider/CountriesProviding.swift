//
//  CountriesProviding.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 18/08/2023.
//

import Foundation

protocol CountriesProviding {
    func getCountries() async throws -> [Country]
}
