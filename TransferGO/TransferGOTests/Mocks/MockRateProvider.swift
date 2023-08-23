//
//  MockRateProvider.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 21/08/2023.
//

import Foundation

class MockRateProvider: RateProviding {
    var shouldThrow: Bool = false
    var errorToThrow: Error? = nil
    var rateToReturn: Double = 1.23456789
    var amountToReturn: Double?
    var errorWasThrown = false
    var numberOfTimesGetRateWasCalled = 0
    
    func getRate(from: Country, to: Country, amount: Double) async throws -> Rate {
        numberOfTimesGetRateWasCalled += 1
        
        if shouldThrow {
            errorWasThrown = true
            throw errorToThrow ?? MockError.someError
        }
        
        try await Task.sleep(nanoseconds: 1_000_000_000)

        return Rate(
            from: from.currencyCode,
            to: to.currencyCode,
            rate: rateToReturn,
            fromAmount: amount,
            toAmount: amountToReturn ?? rateToReturn * amount
        )
    }
}
