//
//  RequestHandling.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 21/08/2023.
//

import Foundation

protocol RequestHandling {
    func getData(from url: URL) async throws -> (Data?, URLResponse?)
}
