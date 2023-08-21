//
//  RateProviding.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 18/08/2023.
//

import Foundation

protocol RateProviding {
    func getRate(from: Country, to: Country, amount: Double) async throws -> Rate
}
