//
//  ResponseHandler.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 21/08/2023.
//

import Foundation

class ResponseHandler: ResponseHandling {
    private let decoder: DataDecoding
    
    init(decoder: DataDecoding) {
        self.decoder = decoder
    }
    
    func handleResponse<T>(data: Data?, response: URLResponse?) throws -> T where T: Decodable {
        guard let response = response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            throw ResponseHandlerError.badResponse
        }
        
        guard let data = data else {
            throw ResponseHandlerError.noData
        }
        
        return try decoder.decode(data: data)
    }
}
