//
//  URLProvider.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 21/08/2023.
//

import Foundation

class URLProvider: URLProviding {
    func getRateURL(_ from: Country, _ to: Country, _ amount: Double) throws -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "my.transfergo.com"
        components.path = "/api/fx-rates"
        components.queryItems = [
            URLQueryItem(name: "from", value: from.currencyCode),
            URLQueryItem(name: "to", value: to.currencyCode),
            URLQueryItem(name: "amount", value: "\(amount)")
        ]
        guard let url = components.url else {
            throw URLProviderError.cannotCreateURL
        }
        return url
    }
}
