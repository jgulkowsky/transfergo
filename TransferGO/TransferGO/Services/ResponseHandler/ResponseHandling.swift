//
//  ResponseHandling.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 21/08/2023.
//

import Foundation

protocol ResponseHandling {
    func handleResponse<T>(data: Data?, response: URLResponse?) throws -> T where T: Decodable
}
