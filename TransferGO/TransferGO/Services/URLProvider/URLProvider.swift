//
//  URLProvider.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 21/08/2023.
//

import Foundation

class URLProvider: URLProviding {
    func getRateURL(_ from: Country, _ to: Country, _ amount: Double) throws -> URL {
        let base = "https://my.transfergo.com/api/fx-rates"
        let fromParam = "from=\(from.currencyCode)"
        let toParam = "to=\(to.currencyCode)"
        let amountParam = "amount=\(amount)"
        guard let url = URL(string: "\(base)?\(fromParam)&\(toParam)&\(amountParam)") else {
            throw URLProviderError.cannotCreateURL
        }
        return url
    }
}
