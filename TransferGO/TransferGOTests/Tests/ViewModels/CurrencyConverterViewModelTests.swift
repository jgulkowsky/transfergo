//
//  CurrencyConverterViewModelTests.swift
//  TransferGOTests
//
//  Created by Jan Gulkowski on 23/08/2023.
//

import XCTest

final class CurrencyConverterViewModelTests: XCTestCase {
    private var viewModel: CurrencyConverterViewModel!
    private var info: CurrencyConverterInfo!
    private var coordinator: MockCoordinator!
    private var rateProvider: MockRateProvider!
    private var scheduler: MockScheduler!
    private var networkStatusProvider: MockNetworkStatusProvider!
    
    override func setUp() {
        info = CurrencyConverterInfo(
            fromCountry: PredefinedCountry.poland,
            toCountry: PredefinedCountry.ukraine,
            fromAmount: 300.0
        )
        coordinator = MockCoordinator()
        rateProvider = MockRateProvider()
        scheduler = MockScheduler()
        networkStatusProvider = MockNetworkStatusProvider()
        
        viewModel = CurrencyConverterViewModel(
            info: info,
            coordinator: coordinator,
            rateProvider: rateProvider,
            scheduler: scheduler,
            networkStatusProvider: networkStatusProvider
        )
    }
    
    // todo: test_givenThatInfoContainsPolandUkraineAnd300
    
    func test_givenThatInfoThatIsPassedOnInitContainsFromPolandToUkraineWithAmount300_whenViewModelIsInitialized_then_fromCountryIsPoland_toCountryIsUkraine_fromAmountIs300With2decimalPlaces_currentRateIsNil_andGetCurrentRateErrorIsNil() {
        // then
        XCTAssertEqual(viewModel.fromCountry, PredefinedCountry.poland)
        XCTAssertEqual(viewModel.toCountry, PredefinedCountry.ukraine)
        XCTAssertEqual(viewModel.fromAmount, "300.00")
        XCTAssertNil(viewModel.currentRate)
        XCTAssertNil(viewModel.getCurrentRateError)
    }
}
