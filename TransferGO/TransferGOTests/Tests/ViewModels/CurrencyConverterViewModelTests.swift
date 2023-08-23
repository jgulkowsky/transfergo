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
        scheduler = MockScheduler(interval: 2.0)
        networkStatusProvider = MockNetworkStatusProvider()
        
        initViewModel()
    }
    
// MARK: - onViewModelInit tests
    
    func test_onViewModelInit_fromCountryToCountryAndFromAmountArePredefined_rateToAmountAndErrorsAreNotSet_fieldsAreEnabled_fromAmountIsNotFocused() {
        // then
        assert_everythingStaysTheSame()
    }
    
    func test_onViewModelInit_whenRateIsGottenWithoutErrors_allStaysTheSame_exceptRateAndToAmountAreSet() {
        // by everythingStaysTheSame I mean the same result as in test_onViewModelInit_fromCountryToCountryAndFromAmountArePredefined_rateToAmountAndErrorsAreNotSet_fieldsAreEnabled_fromAmountIsNotFocused()
        
        // when
        waitForConditionToBeMet {
            self.viewModel.toAmount != nil
        }
        
        // then
        assert_fromCountry_toCountry_tromAmount_areSet()
        assert_toAmount_currentRate_areSet(
            expectedToAmount: 370.370367,
            expectedCurrentRateText: "1 PLN ~ 1.23457 UAH"
        )
        assert_errorsAreNil()
        XCTAssertFalse(viewModel.fromAmountFocused)
    }
    
    func test_onViewModelInit_whenUserTypesStrangeValueThatIsNotConvertibleIntoDouble_everythingStaysTheSame_exceptRateAndToAmountAreNotSet() {
        // by everythingStaysTheSame I mean the same result as in test_onViewModelInit_fromCountryToCountryAndFromAmountArePredefined_rateToAmountAndErrorsAreNotSet_fieldsAreEnabled_fromAmountIsNotFocused()
        
        // when
        let fromAmount = "..12.."
        viewModel.fromAmount = fromAmount
        
        // then
        assert_fromCountry_toCountry_tromAmount_areSet(
            expectedFromAmount: fromAmount
        )
        assert_toAmount_currentRate_areNotSetYet()
        assert_errorsAreNil()
        XCTAssertFalse(viewModel.fromAmountFocused)
    }

    func test_onViewModelInit_whenUserTapsOnFromAmountTextField_everythingStaysTheSame_exceptRateAndToAmountAreNotSet() {
        // by everythingStaysTheSame I mean the same result as in test_onViewModelInit_fromCountryToCountryAndFromAmountArePredefined_rateToAmountAndErrorsAreNotSet_fieldsAreEnabled_fromAmountIsNotFocused()
        
        // when
        viewModel.fromAmountFocused = true
        
        // then
        assert_fromCountry_toCountry_tromAmount_areSet(
            expectedFromAmount: "300.00" // fromAmount will be zeroed soon but because of how textField works it's not yet
        )
        assert_toAmount_currentRate_areNotSetYet()
        assert_errorsAreNil()
        XCTAssertTrue(viewModel.fromAmountFocused)
    }
    
    func test_onViewModelInit_whenUserTypesFromAmountValueOverTheLimit_everythingStaysTheSame_exceptRateAndToAmountAreNotSet_andLimitExceededErrorIsShown() {
        // by everythingStaysTheSame I mean the same result as in test_onViewModelInit_fromCountryToCountryAndFromAmountArePredefined_rateToAmountAndErrorsAreNotSet_fieldsAreEnabled_fromAmountIsNotFocused()
        
        // when
        let fromAmount = "1000000.00" // this should be over any currency limit
        viewModel.fromAmount = fromAmount
        
        // then
        assert_fromCountry_toCountry_tromAmount_areSet(
            expectedFromAmount: fromAmount
        )
        assert_toAmount_currentRate_areNotSetYet()
        assert_errorsAreNil(exceptLimitExceededError: true)
        XCTAssertFalse(viewModel.fromAmountFocused)
    }
    
    func test_onViewModelInit_whenErrorIsThrownDuringGettingRate_andThisErrorIsNotURLErrorCancelledNorCancellationError_everythingStaysTheSame_exceptGetCurrentRateErrorIsSet() {
        // by everythingStaysTheSame I mean the same result as in test_onViewModelInit_fromCountryToCountryAndFromAmountArePredefined_rateToAmountAndErrorsAreNotSet_fieldsAreEnabled_fromAmountIsNotFocused()
        
        // given
        rateProvider = MockRateProvider()
        rateProvider.shouldThrow = true
        
        // then
        initViewModel()
        waitForConditionToBeMet {
            self.viewModel.getCurrentRateError != nil
        }
        
        assert_fromCountry_toCountry_tromAmount_areSet()
        assert_toAmount_currentRate_areNotSetYet()
        assert_errorsAreNil(exceptGetCurrentRateError: true)
        XCTAssertFalse(viewModel.fromAmountFocused)
    }
    
    func test_onViewModelInit_whenErrorIsThrownDuringGettingRate_andThisErrorIsURLErrorCancelled_everythingStaysTheSame() {
        // by everythingStaysTheSame I mean the same result as in test_onViewModelInit_fromCountryToCountryAndFromAmountArePredefined_rateToAmountAndErrorsAreNotSet_fieldsAreEnabled_fromAmountIsNotFocused()
        
        // given
        rateProvider = MockRateProvider()
        rateProvider.shouldThrow = true
        rateProvider.errorToThrow = URLError(.cancelled)
        
        // then
        initViewModel()
        waitForConditionToBeMet {
            self.rateProvider.errorWasThrown
        }
        
        assert_everythingStaysTheSame()
    }
    
    func test_onViewModelInit_whenErrorIsThrownDuringGettingRate_andThisErrorIsCancellationError_everythingStaysTheSame() {
        // by everythingStaysTheSame I mean the same result as in test_onViewModelInit_fromCountryToCountryAndFromAmountArePredefined_rateToAmountAndErrorsAreNotSet_fieldsAreEnabled_fromAmountIsNotFocused()
        
        // given
        rateProvider = MockRateProvider()
        rateProvider.shouldThrow = true
        rateProvider.errorToThrow = CancellationError()
        
        // then
        initViewModel()
        waitForConditionToBeMet {
            self.rateProvider.errorWasThrown
        }
        
        assert_everythingStaysTheSame()
    }
    
// MARK: - onSceneActive / onSceneInactive / onSceneInBackground tests
    
    func test_onSceneActive_shouldStartRegularCurrentRateUpdates() {
        // given
        let timeout = 5.0
        let numberOfTimesEventWasFired = Int(1 + timeout / scheduler.interval)
        
        // when
        viewModel.onSceneActive()
        
        // then
        XCTAssertTrue(scheduler.hasStarted)
        wait(numberOfSeconds: timeout, thenCheck: {
            XCTAssertEqual(scheduler.numberOfTimesEventWasFired, numberOfTimesEventWasFired)
            // if scheduler.numberOfTimesEventWasFired = 1 then we didn't start regular rate updates
            XCTAssertTrue(rateProvider.numberOfTimesGetRateWasCalled > 1) // todo: for some reason we have even more calls to getRate - probably because some of them are cancelled - but here it should be enough to say that we just have more than 1 - so we started regular getRate calls
        })
    }
    
    func test_onSceneActive_shouldStartGettingNetworkStatus() {
        // when
        viewModel.onSceneActive()
        
        // then
        XCTAssertTrue(networkStatusProvider.hasStarted)
        XCTAssertFalse(networkStatusProvider.hasFinished)
    }
    
    func test_givenThatSceneIsActive_whenSceneGetsInactive_shouldStopRegularCurrentRateUpdates() {
        // when
        viewModel.onSceneActive()
        viewModel.onSceneInactive()
        
        // then
        XCTAssertTrue(scheduler.hasStarted)
        XCTAssertTrue(scheduler.hasStopped)
    }
    
    func test_givenThatSceneIsActive_whenSceneGetsInactive_shouldStopGettingNetworkStatus() {
        // when
        viewModel.onSceneActive()
        viewModel.onSceneInactive()
        
        // then
        XCTAssertTrue(networkStatusProvider.hasStarted)
        XCTAssertTrue(networkStatusProvider.hasFinished)
    }
    
    func test_givenThatSceneIsActive_whenSceneGetsIntoBackground_shouldStopRegularCurrentRateUpdates() {
        // when
        viewModel.onSceneActive()
        viewModel.onSceneInBackground()
        
        // then
        XCTAssertTrue(scheduler.hasStarted)
        XCTAssertTrue(scheduler.hasStopped)
    }
    
    func test_givenThatSceneIsActive_whenSceneGetsIntoBackground_shouldStopGettingNetworkStatus() {
        // when
        viewModel.onSceneActive()
        viewModel.onSceneInBackground()
        
        // then
        XCTAssertTrue(networkStatusProvider.hasStarted)
        XCTAssertTrue(networkStatusProvider.hasFinished)
    }
    
// MARK: - sendFromTapped / sendToTapped / switchTapped / backgroundTapped tests
    
    func test_when_viewModelSendFromTapped_then_fromAmountFocusedIsFalse_coordinatorGoesToSelectCountry_withSelectCountryInfoContainingTypeFrom() {
        // when
        viewModel.sendFromTapped()
        
        // then
        XCTAssertFalse(viewModel.fromAmountFocused)
        XCTAssertTrue(coordinator.wentToSelectCountry)
        XCTAssertEqual(coordinator.infoPassedToSelectCountry!.type, .from)
    }
    
    func test_when_viewModelSendToTapped_then_fromAmountFocusedIsFalse_coordinatorGoesToSelectCountry_withSelectCountryInfoContainingTypeTo() {
        // when
        viewModel.sendToTapped()
        
        // then
        XCTAssertFalse(viewModel.fromAmountFocused)
        XCTAssertTrue(coordinator.wentToSelectCountry)
        XCTAssertEqual(coordinator.infoPassedToSelectCountry!.type, .to)
    }
    
    func test_when_viewModelSwitchTapped_then_fromCountrySwitchesWithToCountry() {
        // given
        viewModel.fromCountry = PredefinedCountry.germany
        viewModel.toCountry = PredefinedCountry.poland
        
        // when
        viewModel.switchTapped()
        
        // then
        XCTAssertEqual(viewModel.fromCountry, PredefinedCountry.poland)
        XCTAssertEqual(viewModel.toCountry, PredefinedCountry.germany)
    }
    
    func test_when_viewModelSwitchTapped_then_fromAmountFocusedIsFalse() {
        // given
        viewModel.fromAmountFocused = true
        
        // when
        viewModel.switchTapped()
        
        // then
        XCTAssertFalse(viewModel.fromAmountFocused)
    }
    
    func test_given_fromAmountIsOverLimitForToCountry_when_viewModelSwitchTapped_then_limitExceededErrorIsShown() {
        // given
        viewModel.limitExceededError = nil
        viewModel.fromCountry = PredefinedCountry.ukraine // 50000 is okay here
        viewModel.toCountry = PredefinedCountry.poland // here not
        viewModel.fromAmount = "50000.00"
        
        // when
        viewModel.switchTapped()
        
        // then
        XCTAssertNotNil(viewModel.limitExceededError)
        XCTAssertTrue(viewModel.limitExceeded)
    }
    
    func test_given_fromAmountIsNotOverLimitForToCountry_when_viewModelSwitchTapped_then_limitExceededErrorIsNotShown() {
        // given
        viewModel.limitExceededError = nil
        viewModel.fromCountry = PredefinedCountry.ukraine // 20000 is okay here
        viewModel.toCountry = PredefinedCountry.poland // and here too
        viewModel.fromAmount = "20000.00"
        
        // when
        viewModel.switchTapped()
        
        // then
        XCTAssertNil(viewModel.limitExceededError)
        XCTAssertFalse(viewModel.limitExceeded)
    }
    
    func test_when_viewModelSwitchTapped_then_rateProviderGetRateIsCalled() {
        // given
        rateProvider.numberOfTimesGetRateWasCalled = 0
        
        // when
        viewModel.switchTapped()
        
        // then
        XCTAssertTrue(rateProvider.numberOfTimesGetRateWasCalled > 0) // can be more than 1 as didSets from fromCountry and toCountry tries to get rate too
    }
    
    func test_when_viewModelBackgroundTapped_then_fromAmountIsNotFocused() {
        // given
        viewModel.fromAmountFocused = true
        
        // when
        viewModel.backgroundTapped()
        
        // then
        XCTAssertFalse(viewModel.fromAmountFocused)
    }
    
// MARK: - setting up fromCountry can change value in toCountry and vice versa tests
    
    func test_givenThat_fromCountryPoland_toCountryUkraine_when_fromCountryChangesIntoUkraine_then_toCountryChangesIntoPoland_soItLooksLikeSwitchButtonWasTapped() {
        // given
        viewModel.fromCountry = PredefinedCountry.poland
        viewModel.toCountry = PredefinedCountry.ukraine
        
        // when
        viewModel.fromCountry = PredefinedCountry.ukraine
        
        // then
        XCTAssertEqual(viewModel.fromCountry, PredefinedCountry.ukraine)
        XCTAssertEqual(viewModel.toCountry, PredefinedCountry.poland)
    }
    
    func test_givenThat_fromCountryPoland_toCountryUkraine_when_toCountryChangesIntoPoland_then_fromCountryChangesIntoUkraine_soItLooksLikeSwitchButtonWasTapped() {
        // given
        viewModel.fromCountry = PredefinedCountry.poland
        viewModel.toCountry = PredefinedCountry.ukraine
        
        // when
        viewModel.toCountry = PredefinedCountry.poland
        
        // then
        XCTAssertEqual(viewModel.fromCountry, PredefinedCountry.ukraine)
        XCTAssertEqual(viewModel.toCountry, PredefinedCountry.poland)
    }
    
    func test_givenThat_fromCountryPoland_toCountryUkraine_when_fromCountryChangesIntoGermany_then_toCountryDoesntChange_asThereIsNoSuchNeed() {
        // given
        viewModel.fromCountry = PredefinedCountry.poland
        viewModel.toCountry = PredefinedCountry.ukraine
        
        // when
        viewModel.fromCountry = PredefinedCountry.germany
        
        // then
        XCTAssertEqual(viewModel.fromCountry, PredefinedCountry.germany)
        XCTAssertEqual(viewModel.toCountry, PredefinedCountry.ukraine)
    }
    
    func test_givenThat_fromCountryPoland_toCountryUkraine_when_toCountryChangesIntoGermany_then_fromCountryDoesntChange_asThereIsNoSuchNeed() {
        // given
        viewModel.fromCountry = PredefinedCountry.poland
        viewModel.toCountry = PredefinedCountry.ukraine
        
        // when
        viewModel.toCountry = PredefinedCountry.germany
        
        // then
        XCTAssertEqual(viewModel.fromCountry, PredefinedCountry.poland)
        XCTAssertEqual(viewModel.toCountry, PredefinedCountry.germany)
    }
    
// MARK: - setting up fromCountry or fromAmount triggers checking limits
    
    func test_givenThat_fromCountryPoland_fromAmount20000_when_fromCountryChangesIntoGermany_thatHasSmallerLimitThan20000_then_limitExceededErrorIsShown() {
        // given
        viewModel.fromCountry = PredefinedCountry.poland
        viewModel.fromAmount = "20000.00"
        viewModel.limitExceededError = nil
        
        // when
        viewModel.fromCountry = PredefinedCountry.germany
        
        // then
        XCTAssertNotNil(viewModel.limitExceededError)
        XCTAssertTrue(viewModel.limitExceeded)
    }
    
    func test_givenThat_fromCountryPoland_fromAmount500_when_fromCountryChangesIntoGermany_thatHasBiggerLimitThan500_then_limitExceededErrorIsNotShown() {
        // given
        viewModel.fromCountry = PredefinedCountry.poland
        viewModel.fromAmount = "500.00"
        viewModel.limitExceededError = "Limit exceeded!"
        
        // when
        viewModel.fromCountry = PredefinedCountry.germany
        
        // then
        XCTAssertNil(viewModel.limitExceededError)
        XCTAssertFalse(viewModel.limitExceeded)
    }
    
    func test_givenThat_fromCountryPoland_and_fromAmount20000_whichIsTheSameAsLimitForPoland_when_fromAmountChangesInto20001_then_limitExceededErrorIsShown() {
        // given
        viewModel.fromCountry = PredefinedCountry.poland
        viewModel.fromAmount = "20000.00"
        viewModel.limitExceededError = nil // 20000 for Poland should not trigger the error but to be sure let's set it up to nil
        
        // when
        viewModel.fromAmount = "20001.00"
        
        // then
        XCTAssertNotNil(viewModel.limitExceededError)
        XCTAssertTrue(viewModel.limitExceeded)
    }
    
    func test_givenThat_fromCountryPoland_and_fromAmount30000_whichIsOverLimitForPoland_when_fromAmountChangesInto20000_then_limitExceededErrorIsHidden() {
        // given
        viewModel.fromCountry = PredefinedCountry.poland
        viewModel.fromAmount = "30000.00"
        viewModel.limitExceededError = "Limit exceeded!" // 30000 for Poland should trigger the error but to be sure let's set it up
        
        // when
        viewModel.fromAmount = "20000.00"
        
        // then
        XCTAssertNil(viewModel.limitExceededError)
        XCTAssertFalse(viewModel.limitExceeded)
    }
    
// MARK: - setting up fromCountry or toCountry or fromAmount triggers getting new rate
    
    func test_when_fromCountryIsSet_andLimitIsNotReached_then_rateProviderGetRateIsTriggered() {
        // given
        viewModel.fromCountry = PredefinedCountry.poland
        viewModel.fromAmount = "100.00"
        viewModel.limitExceededError = nil
        
        rateProvider.numberOfTimesGetRateWasCalled = 0
        
        // when
        viewModel.fromCountry = PredefinedCountry.germany
        
        // then
        XCTAssertNil(viewModel.limitExceededError)
        XCTAssertFalse(viewModel.limitExceeded)
        XCTAssertTrue(rateProvider.numberOfTimesGetRateWasCalled > 0)
    }
    
    func test_when_toCountryIsSet_then_rateProviderGetRateIsTriggered() {
        // given
        viewModel.fromCountry = PredefinedCountry.poland
        viewModel.fromAmount = "100.00"
        viewModel.limitExceededError = nil
        
        viewModel.toCountry = PredefinedCountry.germany
        
        rateProvider.numberOfTimesGetRateWasCalled = 0
        
        // when
        viewModel.toCountry = PredefinedCountry.greatBritain
        
        // then
        XCTAssertTrue(rateProvider.numberOfTimesGetRateWasCalled > 0)
    }
    
    func test_when_fromAmountIsSet_andLimitIsNotReached_then_rateProviderGetRateIsTriggered() {
        // given
        viewModel.fromCountry = PredefinedCountry.poland
        viewModel.fromAmount = "100.00"
        viewModel.limitExceededError = nil
        
        rateProvider.numberOfTimesGetRateWasCalled = 0
        
        // when
        viewModel.fromAmount = "200.00"
        
        // then
        XCTAssertNil(viewModel.limitExceededError)
        XCTAssertFalse(viewModel.limitExceeded)
        XCTAssertTrue(rateProvider.numberOfTimesGetRateWasCalled > 0)
    }
    
// MARK: - connection error
    
    func test_given_networkStatusProviderReturnsFalseOnGetRate_when_viewModelTriggersItWithOnSceneActive_then_connectionErrorIsShown() {
        // given
        viewModel.connectionError = nil
        networkStatusProvider.valueToReturn = false
        networkStatusProvider.hasUpdatedStatusAtLeastOnce = false
        
        // when
        viewModel.onSceneActive()
        waitForConditionToBeMet {
            self.networkStatusProvider.hasUpdatedStatusAtLeastOnce == true
        }
        
        // then
        XCTAssertNotNil(viewModel.connectionError)
    }
    
    func test_given_networkStatusProviderReturnsTrueOnGetRate_when_viewModelTriggersItWithOnSceneActive_then_connectionErrorIsHidden() {
        // given
        viewModel.connectionError = "Connection error!"
        networkStatusProvider.valueToReturn = true
        networkStatusProvider.hasUpdatedStatusAtLeastOnce = false
        
        // when
        viewModel.onSceneActive()
        waitForConditionToBeMet { // todo: this rather should be [weak self] no? - and all these places that uses this waitFor... no?
            // todo: on the other hand we have scheduler stop - and these are only tests so until tests are running fine I don't think we need to make things complcated because of this
            self.networkStatusProvider.hasUpdatedStatusAtLeastOnce == true
        }
        
        // then
        XCTAssertNil(viewModel.connectionError)
    }
    
    // todo: test about tryToUpdateCurrentRate on init - done
    //  todo: also when requirements are not satisfied - done
    //  todo: also when requirements are satisfied - done
    //  todo: also when requirements are satisfied but error is thrown (URLError.cancelled, CancellationError, other) - done
    //  todo: also when requirements are satisfied and there's no error but we get the rate - done
    //  todo: also when you tryToUpdateCurrentRate multiple times
    
    // todo: test about onSceneActive - done
    // todo: test about onSceneInactive - done
    // todo: test about onSceneInBackground - done
    
    // todo: test about sendFromTapped - done
    // todo: test about sendToTapped - done
    // todo: test about switchTapped - done
    // todo: test about backgroundTapped - done
    
    // todo: test about setting up fromCountry can change value in toCountry - done
    // todo: test about setting up toCountry can change value in fromCountry - done
    
    // todo: test about setting up fromCountry checksLimits - done
    // todo: test about setting up fromAmount checksLimits - done
    
    // todo: test about setting up fromCountry tries to updateCurrentRate - done
    // todo: test about setting up toCountry tries to updateCurrentRate - done
    // todo: test about setting up fromAmount tries to updateCurrentRate - done
    
    // todo: test about setting up toAmount (maybe covered in above tests...)
    // todo: test about setting up fromAmountFocused (maybe covered in above tests...)
    // todo: test about setting up currentRate (maybe covered in above tests...)
    
    // todo: test about connectionError (maybe covered in above tests...) - done
    // todo: test about limitExceededError (maybe covered in above tests...)
    // todo: test about getCurrentRateError (maybe covered in above tests...)
    
    // todo: test about shouldEnableFields (maybe covered in above tests...)
    // todo: test about limitExceeded (maybe covered in above tests...)
    
    // todo: test about regularCurrentRateUpdates
    // todo: test about gettingNetworkStatus
}

private extension CurrencyConverterViewModelTests {
    func initViewModel() {
        viewModel = CurrencyConverterViewModel(
            info: info,
            coordinator: coordinator,
            rateProvider: rateProvider,
            scheduler: scheduler,
            networkStatusProvider: networkStatusProvider
        )
    }
    
    func waitForConditionToBeMet(samplingRate: Double = 0.1, timeout: Double = 5.0, condition: @escaping () -> Bool) {
        let expectation = XCTestExpectation(description: #function) // is it important? because we can pass it also from the upper function
        
        let scheduler = SchedulerHelper(interval: samplingRate)
        scheduler.start {
            if condition() {
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: timeout)
        scheduler.stop()
        print("@jgu: after expectation fulfilled or timeouted")
    }
    
    func wait(numberOfSeconds: Double, thenCheck assertions: () -> Void) {
        let exp = expectation(description: #function)
        let result = XCTWaiter.wait(for: [exp], timeout: numberOfSeconds)
        if result == XCTWaiter.Result.timedOut {
            assertions()
        } else {
            XCTFail("Delay interrupted")
        }
    }
    
    // public values are: fromCountry, toCountry, fromAmount, toAmount, fromAmountFocused, currentRateText, connectionError, limitExceededError, getCurrentRateError, shouldEnableFields, limitExceeded
    
    func assert_everythingStaysTheSame() {
        assert_fromCountry_toCountry_tromAmount_areSet()
        assert_toAmount_currentRate_areNotSetYet()
        assert_errorsAreNil()
        XCTAssertFalse(viewModel.fromAmountFocused)
    }
    
    func assert_fromCountry_toCountry_tromAmount_areSet(
        expectedFromCountry: Country = PredefinedCountry.poland,
        expectedToCountry: Country = PredefinedCountry.ukraine,
        expectedFromAmount: String = "300.00"
    ) {
        XCTAssertEqual(viewModel.fromCountry, expectedFromCountry)
        XCTAssertEqual(viewModel.toCountry, expectedToCountry)
        XCTAssertEqual(viewModel.fromAmount, expectedFromAmount)
    }
    
    func assert_toAmount_currentRate_areNotSetYet() {
        XCTAssertNil(viewModel.toAmount)
        XCTAssertEqual(viewModel.currentRateText, "---")
    }
    
    func assert_toAmount_currentRate_areSet(expectedToAmount: Double, expectedCurrentRateText: String) {
        XCTAssertNotNil(viewModel.toAmount)
        if let toAmount = viewModel.toAmount {
            XCTAssertTrue(Double.equal(toAmount, expectedToAmount, precise: 10))
        }
        XCTAssertEqual(viewModel.currentRateText, expectedCurrentRateText)
    }
    
    func assert_errorsAreNil(
        exceptConnectionError: Bool = false,
        exceptLimitExceededError: Bool = false,
        exceptGetCurrentRateError: Bool = false
    ) {
        if exceptConnectionError {
            XCTAssertNotNil(viewModel.connectionError)
            XCTAssertFalse(viewModel.shouldEnableFields)
        } else {
            XCTAssertNil(viewModel.connectionError)
            XCTAssertTrue(viewModel.shouldEnableFields)
        }
        
        if exceptLimitExceededError {
            XCTAssertNotNil(viewModel.limitExceededError)
            XCTAssertTrue(viewModel.limitExceeded)
        } else {
            XCTAssertNil(viewModel.limitExceededError)
            XCTAssertFalse(viewModel.limitExceeded)
        }
        
        if exceptGetCurrentRateError {
            XCTAssertNotNil(viewModel.getCurrentRateError)
        } else {
            XCTAssertNil(viewModel.getCurrentRateError)
        }
    }
}
