//
//  DataDecoding.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 21/08/2023.
//

import Foundation

protocol DataDecoding {
    func decode<T>(data: Data) throws -> T where T: Decodable
}
