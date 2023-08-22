//
//  SelectCountryViewModelTests.swift
//  TransferGOTests
//
//  Created by Jan Gulkowski on 22/08/2023.
//

import XCTest
import Combine

final class SelectCountryViewModelTests: XCTestCase {
    private var viewModel: SelectCountryViewModel!
    private var info: SelectCountryInfo!
    private var coordinator: MockCoordinator!
    private var countriesProvider: MockCountriesProvider!
    
    override func setUp() {
        info = SelectCountryInfo(type: .from)
        coordinator = MockCoordinator()
        countriesProvider = MockCountriesProvider()
        
        viewModel = SelectCountryViewModel(
            info: info,
            coordinator: coordinator,
            countriesProvider: countriesProvider
        )
    }
    
    func test_givenThatSelectCountryInfoHasTypeFrom_whenViewModelIsInitialized_thenTitleIsSetToSendingFrom() {
        XCTAssertEqual(viewModel.title, "Sending from")
    }
    
    func test_givenThatSelectCountryInfoHasTypeTo_whenViewModelIsInitialized_thenTitleIsSetToSendingTo() {
        info = SelectCountryInfo(type: .to)
        viewModel = SelectCountryViewModel(
            info: info,
            coordinator: coordinator,
            countriesProvider: countriesProvider
        )
        
        XCTAssertEqual(viewModel.title, "Sending to")
    }
    
    func test_whenViewModelIsInitialized_thenLoadingIndicatorIsHidden_listIsHidden_andErrorIsHidden() async {
        // then
        XCTAssertEqual(viewModel.showLoadingIndicator, false)
        XCTAssertEqual(viewModel.showList, false)
        XCTAssertEqual(viewModel.showError, false)
    }
    
    // todo: we should probably also update countries to be empty each time we call countriesProvider - that's not done
    func test_givenThatCountriesProviderReturnsListOfCountriesWithoutThrowing_whenViewModelIsGettingAllCountries_thenBeforeTheseCountriesAreGotten_loadingIndicatorIsShown_listIsHidden_andErrorIsHidden() async {
        // when
        let (showLoadingIndicatorValues, showListValues, showErrorValues) = await whenViewModelIsGettingAllCountries_thenThisIsHow_showLoadingIndicator_showList_andShowError_valuesAreSet()
        
        // then
        XCTAssertEqual(showLoadingIndicatorValues[1], true)
        XCTAssertEqual(showListValues[1], false)
        XCTAssertEqual(showErrorValues[1], false)
    }
    
    func test_givenThatCountriesProviderReturnsListOfCountriesWithoutThrowing_whenViewModelIsGettingAllCountries_thenAfterTheseCountriesAreGotten_loadingIndicatorIsHidden_listIsShown_andErrorIsHidden() async {
        // when
        let (showLoadingIndicatorValues, showListValues, showErrorValues) = await whenViewModelIsGettingAllCountries_thenThisIsHow_showLoadingIndicator_showList_andShowError_valuesAreSet()
        
        // then
        XCTAssertEqual(showLoadingIndicatorValues[2], false)
        XCTAssertEqual(showListValues[2], true)
        XCTAssertEqual(showErrorValues[2], false)
    }
    
    func test_givenThatCountriesProviderThrowsDuringGettingListOfCountries_whenViewModelIsGettingAllCountries_thenBeforeErrorIsThrown_loadingIndicatorIsShown_listIsHidden_andErrorIsHidden() async {
        // given
        countriesProvider.shouldThrow = true
        viewModel = SelectCountryViewModel(
            info: info,
            coordinator: coordinator,
            countriesProvider: countriesProvider
        )
        
        // when
        let (showLoadingIndicatorValues, showListValues, showErrorValues) = await whenViewModelIsGettingAllCountries_thenThisIsHow_showLoadingIndicator_showList_andShowError_valuesAreSet()
        
        // then
        XCTAssertEqual(showLoadingIndicatorValues[1], true)
        XCTAssertEqual(showListValues[1], false)
        XCTAssertEqual(showErrorValues[1], false)
    }
    
    func test_givenThatCountriesProviderThrowsDuringGettingListOfCountries_whenViewModelIsGettingAllCountries_thenAfterErrorIsThrown_loadingIndicatorIsHidden_listIsHidden_andErrorIsShown() async {
        // given
        countriesProvider.shouldThrow = true
        viewModel = SelectCountryViewModel(
            info: info,
            coordinator: coordinator,
            countriesProvider: countriesProvider
        )
        
        // when
        let (showLoadingIndicatorValues, showListValues, showErrorValues) = await whenViewModelIsGettingAllCountries_thenThisIsHow_showLoadingIndicator_showList_andShowError_valuesAreSet()
        
        // then
        XCTAssertEqual(showLoadingIndicatorValues[2], false)
        XCTAssertEqual(showListValues[2], false)
        XCTAssertEqual(showErrorValues[2], true)
    }
}

private extension SelectCountryViewModelTests {
    func whenViewModelIsGettingAllCountries_thenThisIsHow_showLoadingIndicator_showList_andShowError_valuesAreSet() async -> (
        showLoadingIndicatorValues: [Bool],
        showListValues: [Bool],
        showErrorValues: [Bool]
    ) {
        var cancellables = Set<AnyCancellable>()
        var showLoadingIndicatorValues: [Bool] = []
        var showListValues: [Bool] = []
        var showErrorValues: [Bool] = []
        viewModel.$showLoadingIndicator.sink { showLoadingIndicatorValues.append($0) }.store(in: &cancellables)
        viewModel.$showList.sink { showListValues.append($0) }.store(in: &cancellables)
        viewModel.$showError.sink { showErrorValues.append($0) }.store(in: &cancellables)
        
        await viewModel.getAllCountries()
        
        return (
            showLoadingIndicatorValues: showLoadingIndicatorValues,
            showListValues: showListValues,
            showErrorValues: showErrorValues
        )
    }
}
