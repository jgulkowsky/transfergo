//
//  RateProvider.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 18/08/2023.
//

import Foundation

class RateProvider: RateProviding {
    func getRate(from: Country, to: Country, amount: Double) async throws -> Rate {
        // todo: make call to https://my.transfergo.com/api/fx-rates?from=PLN&to=UAH&amount=1000.49
        
        try await Task.sleep(nanoseconds: 2_000_000_000) // todo: remove later on when we have actual call to remote service
        
        return Rate(
            from: "PLN",
            to: "UAH",
            rate: 8.99932,
            fromAmount: 300.0,
            toAmount: 2699.8
        )
    }
}
