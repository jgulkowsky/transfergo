//
//  RateProvider.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 18/08/2023.
//

import Foundation

class RateProvider: RateProviding {
    private let urlProvider: URLProviding
    private let requestHandler: RequestHandling
    private let responseHandler: ResponseHandling
    
    init(urlProvider: URLProviding,
         requestHandler: RequestHandling,
         responseHandler: ResponseHandling) {
        self.urlProvider = urlProvider
        self.requestHandler = requestHandler
        self.responseHandler = responseHandler
    }
    
    func getRate(from: Country, to: Country, amount: Double) async throws -> Rate {
        let url = try urlProvider.getRateURL(from, to, amount)
        let (data, response) = try await requestHandler.getData(from: url)
        return try responseHandler.handleResponse(data: data, response: response)
    }
}
