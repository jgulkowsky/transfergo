//
//  URLProviderTests.swift
//  TransferGOTests
//
//  Created by Jan Gulkowski on 22/08/2023.
//

import XCTest

final class URLProviderTests: XCTestCase {
    private var urlProvider: URLProvider!
    
    override func setUp() {
        urlProvider = URLProvider()
    }
    
    func test_getRateURL_whenCountry1IsPoland_andCountry2IsUkraine_andAmountIs300_itShouldReturnCorrectURL() {
        do {
            let url = try urlProvider.getRateURL(PredefinedCountry.poland, PredefinedCountry.ukraine, 300.0)
            let expectedURL = URL(string: "https://my.transfergo.com/api/fx-rates?from=PLN&to=UAH&amount=300.0")!
            XCTAssertEqual(url, expectedURL)
        } catch {
            XCTFail("It should never throw") // at least when currencyCode is not nullable
            // todo: when we get Countries from some backend and this field could be nil - we should check for such scenario
        }
    }
}
