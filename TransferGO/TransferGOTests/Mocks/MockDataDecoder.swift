//
//  MockDataDecoder.swift
//  TransferGOTests
//
//  Created by Jan Gulkowski on 22/08/2023.
//

import Foundation

class MockDataDecoder: DataDecoding {
    var shouldThrow: Bool
    
    private let decoder = JSONDecoder()
    
    init(shouldThrow: Bool = false) {
        self.shouldThrow = shouldThrow
    }
    
    func decode<T>(data: Data) throws -> T where T: Decodable {
        if shouldThrow {
            throw MockError.someError
        }
        return try decoder.decode(T.self, from: data)
    }
}
