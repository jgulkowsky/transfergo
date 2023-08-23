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
    
    // todo: in normal situation CountriesProvider would contain RequestHandler etc so there were be some classes that could throw and we needed to check this - but now we don't have to
    
    // todo: we should add some test about prefetching and cache
}
