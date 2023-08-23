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
    
    // public values are: fromCountry, toCountry, fromAmount, toAmount, fromAmountFocused, currentRateText, connectionError, limitExceededError, getCurrentRateError, shouldEnableFields, limitExceeded
    
    func test_givenThatInfoThatIsPassedOnInitContainsFromPolandToUkraineWithAmount300_whenViewModelIsInitialized_then_fromCountryIsPoland_toCountryIsUkraine_fromAmountIs300With2decimalPlaces_andGetCurrentRateErrorIsNil() {
        // then
        XCTAssertEqual(viewModel.fromCountry, PredefinedCountry.poland)
        XCTAssertEqual(viewModel.toCountry, PredefinedCountry.ukraine)
        XCTAssertEqual(viewModel.fromAmount, "300.00")
        XCTAssertNil(viewModel.getCurrentRateError)
    }
    
    
    
    // todo: test about tryToUpdateCurrentRate on init
    //  todo: also when requirements are not satisfied
    //  todo: also when requirements are satisfied
    //  todo: also when requirements are satisfied but error is thrown (URLError.cancelled, CancellationError, other)
    //  todo: also when requirements are satisfied and there's no error but we get the rate
    //  todo: also when you tryToUpdateCurrentRate multiple times
    
    // todo: test about onSceneActive
    // todo: test about onSceneInactive
    // todo: test about onSceneInBackground
    
    // todo: test about sendFromTapped
    // todo: test about sendToTapped
    // todo: test about switchTapped
    // todo: test about backgroundTapped
    
    // todo: test about setting up fromCountry can change value in toCountry
    // todo: test about setting up toCountry can change value in fromCountry
    
    // todo: test about setting up fromCountry checksLimits
    // todo: test about setting up fromAmount checksLimits
    
    // todo: test about setting up fromCountry tries to updateCurrentRate
    // todo: test about setting up toCountry tries to updateCurrentRate
    // todo: test about setting up fromAmount tries to updateCurrentRate
    
    // todo: test about setting up toAmount (maybe covered in above tests...)
    // todo: test about setting up fromAmountFocused (maybe covered in above tests...)
    // todo: test about setting up currentRate (maybe covered in above tests...)
    
    // todo: test about connectionError (maybe covered in above tests...)
    // todo: test about limitExceededError (maybe covered in above tests...)
    // todo: test about getCurrentRateError (maybe covered in above tests...)
    
    // todo: test about shouldEnableFields (maybe covered in above tests...)
    // todo: test about limitExceeded (maybe covered in above tests...)
    
    // todo: test about regularCurrentRateUpdates
    // todo: test about gettingNetworkStatus
}
