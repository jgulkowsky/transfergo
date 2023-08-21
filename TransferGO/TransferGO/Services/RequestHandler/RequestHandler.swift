//
//  RequestHandler.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 21/08/2023.
//

import Foundation

actor RequestHandler: RequestHandling {
    func getData(from url: URL) async throws -> (Data?, URLResponse?) {
        return try await URLSession.shared.data(from: url, delegate: nil)
    }
}
