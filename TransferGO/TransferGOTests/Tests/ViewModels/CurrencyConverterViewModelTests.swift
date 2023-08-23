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
    
    func test_onViewModelInit_fromCountryToCountryAndFromAmountArePredefined_rateToAmountAndErrorsAreNotSet_fieldsAreEnabled_fromAmountIsNotFocused() {
        // then
        assertEverythingStaysTheSame()
    }
    
    func test_onViewModelInit_whenRateIsGottenWithoutErrors_allStaysTheSame_exceptRateAndToAmountAreSet() {
        // by everythingStaysTheSame I mean the same result as in test_onViewModelInit_fromCountryToCountryAndFromAmountArePredefined_rateToAmountAndErrorsAreNotSet_fieldsAreEnabled_fromAmountIsNotFocused()
        
        // then
        waitForConditionToBeMet {
            self.viewModel.toAmount != nil
        }
        
        XCTAssertEqual(viewModel.fromCountry, PredefinedCountry.poland)
        XCTAssertEqual(viewModel.toCountry, PredefinedCountry.ukraine)
        XCTAssertEqual(viewModel.fromAmount, "300.00")
        XCTAssertNotNil(viewModel.toAmount)
        if let toAmount = viewModel.toAmount {
            XCTAssertTrue(Double.equal(toAmount, 370.370367, precise: 10))
        }
        XCTAssertFalse(viewModel.fromAmountFocused)
        XCTAssertEqual(viewModel.currentRateText, "1 PLN ~ 1.23457 UAH")
        XCTAssertNil(viewModel.connectionError)
        XCTAssertNil(viewModel.limitExceededError)
        XCTAssertNil(viewModel.getCurrentRateError)
        XCTAssertTrue(viewModel.shouldEnableFields)
        XCTAssertFalse(viewModel.limitExceeded)
    }
    
    func test_onViewModelInit_whenUserTypesStrangeValueThatIsNotConvertibleIntoDouble_everythingStaysTheSame_exceptRateAndToAmountAreNotSet() {
        // by everythingStaysTheSame I mean the same result as in test_onViewModelInit_fromCountryToCountryAndFromAmountArePredefined_rateToAmountAndErrorsAreNotSet_fieldsAreEnabled_fromAmountIsNotFocused()
        
        // when
        viewModel.fromAmount = "..12.."
        
        // then
        XCTAssertEqual(viewModel.fromCountry, PredefinedCountry.poland)
        XCTAssertEqual(viewModel.toCountry, PredefinedCountry.ukraine)
        XCTAssertEqual(viewModel.fromAmount, "..12..")
        XCTAssertNil(viewModel.toAmount)
        XCTAssertFalse(viewModel.fromAmountFocused)
        XCTAssertEqual(viewModel.currentRateText, "---")
        XCTAssertNil(viewModel.connectionError)
        XCTAssertNil(viewModel.limitExceededError)
        XCTAssertNil(viewModel.getCurrentRateError)
        XCTAssertTrue(viewModel.shouldEnableFields)
        XCTAssertFalse(viewModel.limitExceeded)
    }

    func test_onViewModelInit_whenUserTapsOnFromAmountTextField_everythingStaysTheSame_exceptRateAndToAmountAreNotSet() {
        // by everythingStaysTheSame I mean the same result as in test_onViewModelInit_fromCountryToCountryAndFromAmountArePredefined_rateToAmountAndErrorsAreNotSet_fieldsAreEnabled_fromAmountIsNotFocused()
        
        // when
        viewModel.fromAmountFocused = true
        
        // then
        XCTAssertEqual(viewModel.fromCountry, PredefinedCountry.poland)
        XCTAssertEqual(viewModel.toCountry, PredefinedCountry.ukraine)
        XCTAssertEqual(viewModel.fromAmount, "300.00") // it will be zeroed in a short time but not now
        XCTAssertNil(viewModel.toAmount)
        XCTAssertTrue(viewModel.fromAmountFocused)
        XCTAssertEqual(viewModel.currentRateText, "---")
        XCTAssertNil(viewModel.connectionError)
        XCTAssertNil(viewModel.limitExceededError)
        XCTAssertNil(viewModel.getCurrentRateError)
        XCTAssertTrue(viewModel.shouldEnableFields)
        XCTAssertFalse(viewModel.limitExceeded)
    }
    
    func test_onViewModelInit_whenUserTypesFromAmountValueOverTheLimit_everythingStaysTheSame_exceptRateAndToAmountAreNotSet_andLimitExceededErrorIsShown() {
        // by everythingStaysTheSame I mean the same result as in test_onViewModelInit_fromCountryToCountryAndFromAmountArePredefined_rateToAmountAndErrorsAreNotSet_fieldsAreEnabled_fromAmountIsNotFocused()
        
        // when
        viewModel.fromAmount = "1000000.00" // this should be over any currency limit
        
        // then
        XCTAssertEqual(viewModel.fromCountry, PredefinedCountry.poland)
        XCTAssertEqual(viewModel.toCountry, PredefinedCountry.ukraine)
        XCTAssertEqual(viewModel.fromAmount, "1000000.00")
        XCTAssertNil(viewModel.toAmount)
        XCTAssertFalse(viewModel.fromAmountFocused)
        XCTAssertEqual(viewModel.currentRateText, "---")
        XCTAssertNil(viewModel.connectionError)
        XCTAssertNotNil(viewModel.limitExceededError)
        XCTAssertNil(viewModel.getCurrentRateError)
        XCTAssertTrue(viewModel.shouldEnableFields)
        XCTAssertTrue(viewModel.limitExceeded)
    }
    
    func test_onViewModelInit_whenErrorIsThrownDuringGettingRate_andThisErrorIsNotURLErrorCancelledNorCancellationError_everythingStaysTheSame_exceptGetCurrentRateErrorIsSet() {
        // by everythingStaysTheSame I mean the same result as in test_onViewModelInit_fromCountryToCountryAndFromAmountArePredefined_rateToAmountAndErrorsAreNotSet_fieldsAreEnabled_fromAmountIsNotFocused()
        
        // given
        rateProvider = MockRateProvider()
        rateProvider.shouldThrow = true
        
        viewModel = CurrencyConverterViewModel(
            info: info,
            coordinator: coordinator,
            rateProvider: rateProvider,
            scheduler: scheduler,
            networkStatusProvider: networkStatusProvider
        )
        
        // then
        waitForConditionToBeMet {
            self.viewModel.getCurrentRateError != nil
        }
        
        XCTAssertEqual(viewModel.fromCountry, PredefinedCountry.poland)
        XCTAssertEqual(viewModel.toCountry, PredefinedCountry.ukraine)
        XCTAssertEqual(viewModel.fromAmount, "300.00")
        XCTAssertNil(viewModel.toAmount)
        XCTAssertFalse(viewModel.fromAmountFocused)
        XCTAssertEqual(viewModel.currentRateText, "---")
        XCTAssertNil(viewModel.connectionError)
        XCTAssertNil(viewModel.limitExceededError)
        XCTAssertNotNil(viewModel.getCurrentRateError)
        XCTAssertTrue(viewModel.shouldEnableFields)
        XCTAssertFalse(viewModel.limitExceeded)
    }
    
    func test_onViewModelInit_whenErrorIsThrownDuringGettingRate_andThisErrorIsURLErrorCancelled_everythingStaysTheSame() {
        // by everythingStaysTheSame I mean the same result as in test_onViewModelInit_fromCountryToCountryAndFromAmountArePredefined_rateToAmountAndErrorsAreNotSet_fieldsAreEnabled_fromAmountIsNotFocused()
        
        // given
        rateProvider = MockRateProvider()
        rateProvider.shouldThrow = true
        rateProvider.errorToThrow = URLError(.cancelled)
        
        viewModel = CurrencyConverterViewModel(
            info: info,
            coordinator: coordinator,
            rateProvider: rateProvider,
            scheduler: scheduler,
            networkStatusProvider: networkStatusProvider
        )
        
        // then
        waitForConditionToBeMet {
            self.rateProvider.errorWasThrown
        }
        
        assertEverythingStaysTheSame()
    }
    
    func test_onViewModelInit_whenErrorIsThrownDuringGettingRate_andThisErrorIsCancellationError_everythingStaysTheSame() {
        // by everythingStaysTheSame I mean the same result as in test_onViewModelInit_fromCountryToCountryAndFromAmountArePredefined_rateToAmountAndErrorsAreNotSet_fieldsAreEnabled_fromAmountIsNotFocused()
        
        // given
        rateProvider = MockRateProvider()
        rateProvider.shouldThrow = true
        rateProvider.errorToThrow = CancellationError()
        
        // todo: this also could be put into separate function
        viewModel = CurrencyConverterViewModel(
            info: info,
            coordinator: coordinator,
            rateProvider: rateProvider,
            scheduler: scheduler,
            networkStatusProvider: networkStatusProvider
        )
        
        // then
        waitForConditionToBeMet {
            self.rateProvider.errorWasThrown
        }
        
        assertEverythingStaysTheSame()
    }
    
    // todo: test about tryToUpdateCurrentRate on init - done
    //  todo: also when requirements are not satisfied - done
    //  todo: also when requirements are satisfied - done
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

private extension CurrencyConverterViewModelTests {
    func waitForConditionToBeMet(samplingRate: Double = 0.1, timeout: Double = 5.0, condition: @escaping () -> Bool) {
        let expectation = XCTestExpectation(description: #function) // is it important? because we can pass it also from the upper function
        
        let scheduler = SchedulerHelper()
        scheduler.start(
            withInterval: samplingRate,
            onEvent: {
                if condition() {
                    expectation.fulfill()
                }
            }
        )
        
        wait(for: [expectation], timeout: timeout)
        scheduler.stop()
        print("@jgu: after expectation fulfilled or timeouted")
    }
    
    func assertEverythingStaysTheSame() {
        XCTAssertEqual(viewModel.fromCountry, PredefinedCountry.poland)
        XCTAssertEqual(viewModel.toCountry, PredefinedCountry.ukraine)
        XCTAssertEqual(viewModel.fromAmount, "300.00")
        XCTAssertNil(viewModel.toAmount)
        XCTAssertFalse(viewModel.fromAmountFocused)
        XCTAssertEqual(viewModel.currentRateText, "---")
        XCTAssertNil(viewModel.connectionError)
        XCTAssertNil(viewModel.limitExceededError)
        XCTAssertNil(viewModel.getCurrentRateError)
        XCTAssertTrue(viewModel.shouldEnableFields)
        XCTAssertFalse(viewModel.limitExceeded)
    }
}
