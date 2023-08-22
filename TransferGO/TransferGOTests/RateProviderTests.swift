//
//  RateProviderTests.swift
//  TransferGOTests
//
//  Created by Jan Gulkowski on 22/08/2023.
//

import XCTest

final class RateProviderTests: XCTestCase {
    private var rateProvider: RateProvider!
    private var mockURLProvider: MockURLProvider!
    private var mockRequestHandler: MockRequestHandler!
    private var mockResponseHandler: MockResponseHandler<Rate>!
    
    override func setUp() {
        mockURLProvider = MockURLProvider()
        mockURLProvider.shouldThrow = false
        
        mockRequestHandler = MockRequestHandler()
        mockRequestHandler.shouldThrow = false
        mockRequestHandler.returnValue = (
            TestHelper.getData(),
            TestHelper.getResponse(withStatusCode: 200)
        )
        
        mockResponseHandler = MockResponseHandler()
        mockResponseHandler.shouldThrow = false
        mockResponseHandler.returnValue = TestHelper.getRate()
        
        rateProvider = RateProvider(
            urlProvider: mockURLProvider,
            requestHandler: mockRequestHandler,
            responseHandler: mockResponseHandler
        )
    }
    
    func test_whenGetRateIsCalled_andURLProviderThrows_thenRateProviderThrowsToo_andOnlyURLProviderWasCalled() {
        Task {
            do {
                mockURLProvider.shouldThrow = true
                _ = try await rateProvider.getRate(
                    from: PredefinedCountry.poland,
                    to: PredefinedCountry.ukraine,
                    amount: 1000.0
                )
                XCTFail("it should throw but it returned")
            } catch {
                XCTAssert(true)
                XCTAssertTrue(mockURLProvider.wasCalled)
                XCTAssertFalse(mockRequestHandler.wasCalled)
                XCTAssertFalse(mockResponseHandler.wasCalled)
            }
        }
    }
    
    func test_whenGetRateIsCalled_andRequestHandlerThrows_thenRateProviderThrowsToo_andBoth_URLProvider_andRequestHandlerWereCalled() {
        Task {
            do {
                mockRequestHandler.shouldThrow = true
                _ = try await rateProvider.getRate(
                    from: PredefinedCountry.poland,
                    to: PredefinedCountry.ukraine,
                    amount: 1000.0
                )
                XCTFail("it should throw but it returned")
            } catch {
                XCTAssert(true)
                XCTAssertTrue(mockURLProvider.wasCalled)
                XCTAssertTrue(mockRequestHandler.wasCalled)
                XCTAssertFalse(mockResponseHandler.wasCalled)
            }
        }
    }
    
    func test_whenGetRateIsCalled_andRequestHandlerThrows_thenRateProviderThrowsToo_andAll_URLProvider_requestHandler_andResponseHandlerWereCalled() {
        Task {
            do {
                mockResponseHandler.shouldThrow = true
                _ = try await rateProvider.getRate(
                    from: PredefinedCountry.poland,
                    to: PredefinedCountry.ukraine,
                    amount: 1000.0
                )
                XCTFail("it should throw but it returned")
            } catch {
                XCTAssert(true)
                XCTAssertTrue(mockURLProvider.wasCalled)
                XCTAssertTrue(mockRequestHandler.wasCalled)
                XCTAssertTrue(mockResponseHandler.wasCalled)
            }
        }
    }
    
    func test_whenGetRateIsCalled_andNooneThrows_thenRateProviderReturnsRateFromResponseHandler() {
        Task {
            do {
                let rate = try await rateProvider.getRate(
                    from: PredefinedCountry.poland,
                    to: PredefinedCountry.ukraine,
                    amount: 1000.0
                )
                XCTAssertEqual(rate, TestHelper.getRate())
            } catch {
                XCTFail("it should not throw")
            }
        }
    }
}
