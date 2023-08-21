//
//  URLProviding.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 21/08/2023.
//

import Foundation

protocol URLProviding {
    func getRateURL(_ from: Country, _ to: Country, _ amount: Double) throws -> URL
}
