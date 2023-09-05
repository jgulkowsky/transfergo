//
//  CountriesProviderTests.swift
//  TransferGOTests
//
//  Created by Jan Gulkowski on 23/08/2023.
//

import XCTest

final class CountriesProviderTests: XCTestCase {
    private var countriesProvider: CountriesProvider!
    
    override func setUp() {
        countriesProvider = CountriesProvider()
    }
    
    func test_when_countriesProviderGetsCountries_then_4CountriesShouldBeReturned() async {
        // when
        let countries = try? await countriesProvider.getCountries()
        
        // then
        let expectedCountries = [
            PredefinedCountry.poland,
            PredefinedCountry.germany,
            PredefinedCountry.greatBritain,
            PredefinedCountry.ukraine
        ]
        XCTAssertEqual(countries, expectedCountries)
    }
}
