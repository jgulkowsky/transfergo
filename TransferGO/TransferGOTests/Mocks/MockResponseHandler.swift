//
//  MockResponseHandler.swift
//  TransferGOTests
//
//  Created by Jan Gulkowski on 22/08/2023.
//

import Foundation

class MockResponseHandler<T>: ResponseHandling {
    var shouldThrow = false
    var returnValue: T! // todo: not sure if this is ok
    var wasCalled = false
    
    func handleResponse<T>(data: Data?, response: URLResponse?) throws -> T where T : Decodable {
        wasCalled = true
        if shouldThrow {
            throw MockError.someError
        }
        return returnValue as! T // todo: and this
    }
}
