//
//  Double+limitDecimalPlacesTests.swift
//  TransferGOTests
//
//  Created by Jan Gulkowski on 23/08/2023.
//

import XCTest

final class Double_limitDecimalPlacesTests: XCTestCase {
    func test_givenDouble_1_dot_23456789_when_itIsLimitedTo_0_DecPlaces_then_stringIsReturned_1() {
        XCTAssertEqual(1.23456789.limitDecimalPlaces(to: 0), "1") // rounding down
    }
    
    func test_givenDouble_1_dot_23456789_when_itIsLimitedTo_1_DecPlaces_then_stringIsReturned_1_dot_2() {
        XCTAssertEqual(1.23456789.limitDecimalPlaces(to: 1), "1.2") // rounding down
    }
    
    func test_givenDouble_1_dot_23456789_when_itIsLimitedTo_2_DecPlaces_then_stringIsReturned_1_dot_23() {
        XCTAssertEqual(1.23456789.limitDecimalPlaces(to: 2), "1.23") // rounding down
    }
    
    func test_givenDouble_1_dot_23456789_when_itIsLimitedTo_3_DecPlaces_then_stringIsReturned_1_dot_235() {
        XCTAssertEqual(1.23456789.limitDecimalPlaces(to: 3), "1.235") // rounding up
    }
    
    func test_givenDouble_1_dot_23456789_when_itIsLimitedTo_4_DecPlaces_then_stringIsReturned_1_dot_2346() {
        XCTAssertEqual(1.23456789.limitDecimalPlaces(to: 4), "1.2346") // rounding up
    }
    
    func test_givenDouble_1_dot_23456789_when_itIsLimitedTo_5_DecPlaces_then_stringIsReturned_1_dot_23457() {
        XCTAssertEqual(1.23456789.limitDecimalPlaces(to: 5), "1.23457") // rounding up
    }
}
