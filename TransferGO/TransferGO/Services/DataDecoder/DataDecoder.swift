//
//  DataDecoder.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 21/08/2023.
//

import Foundation

class DataDecoder: DataDecoding {
    private let decoder = JSONDecoder()
    
    func decode<T>(data: Data) throws -> T where T: Decodable {
        return try decoder.decode(T.self, from: data)
    }
}
