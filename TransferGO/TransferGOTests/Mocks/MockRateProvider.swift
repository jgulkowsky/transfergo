//
//  MockRateProvider.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 21/08/2023.
//

import Foundation

class MockRateProvider: RateProviding {
    func getRate(from: Country, to: Country, amount: Double) async throws -> Rate {
        try await Task.sleep(nanoseconds: 2_000_000_000)
        let rate = getRandomRate()
        return Rate(
            from: from.currencyCode,
            to: to.currencyCode,
            rate: rate,
            fromAmount: amount,
            toAmount: rate * amount
        )
    }
}

private extension MockRateProvider {
    func getRandomRate() -> Double {
        return Double.random(in: 1..<10)
    }
}
