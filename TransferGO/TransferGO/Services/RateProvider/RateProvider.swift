//
//  RateProvider.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 18/08/2023.
//

import Foundation

// todo: move it to separate file
enum RateProviderError: Error {
    case dataNil
    case cannotCreateUrl
}

class RateProvider: RateProviding {
    func handleResponse(data: Data?, response: URLResponse?) throws -> Rate {
        // todo: also check if response has correct status code
        let decoder = JSONDecoder()
        guard let data = data else {
            throw RateProviderError.dataNil
        }
        return try decoder.decode(Rate.self, from: data)
    }
    
    func getRate(from: Country, to: Country, amount: Double) async throws -> Rate {
        // todo: make call to https://my.transfergo.com/api/fx-rates?from=PLN&to=UAH&amount=1000.49
        let base = "https://my.transfergo.com/api/fx-rates"
        let fromParam = "from=\(from.currencyCode)"
        let toParam = "to=\(to.currencyCode)"
        let amountParam = "amount=\(amount)"
        guard let url = URL(string: "\(base)?\(fromParam)&\(toParam)&\(amountParam)") else {
            throw RateProviderError.cannotCreateUrl
        }
        
        // todo: do it in actor
        let (data, response) = try await URLSession.shared.data(from: url, delegate: nil)
        
        return try handleResponse(data: data, response: response)
    }
}

// todo: use more parts here - Decoder, RequestHandler, ResponseHandler etc - and make it more generic - not only related to Rate
