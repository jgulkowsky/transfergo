//
//  MockRequestHandler.swift
//  TransferGOTests
//
//  Created by Jan Gulkowski on 22/08/2023.
//

import Foundation

class MockRequestHandler: RequestHandling {
    var shouldThrow = false
    var returnValue: (Data?, URLResponse?)!
    var wasCalled = false
    
    func getData(from url: URL) async throws -> (Data?, URLResponse?) {
        wasCalled = true
        if shouldThrow {
            throw MockError.someError
        }
        return returnValue
    }
}
