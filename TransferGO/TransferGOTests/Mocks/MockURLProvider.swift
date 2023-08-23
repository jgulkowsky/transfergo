//
//  MockURLProvider.swift
//  TransferGOTests
//
//  Created by Jan Gulkowski on 22/08/2023.
//

import Foundation

class MockURLProvider: URLProviding {
    var shouldThrow = false
    var wasCalled = false
    
    func getRateURL(_ from: Country, _ to: Country, _ amount: Double) throws -> URL {
        wasCalled = true
        if shouldThrow {
            throw MockError.someError
        }
        return URL(string: "https://some.valid.url.com")!
    }
}
