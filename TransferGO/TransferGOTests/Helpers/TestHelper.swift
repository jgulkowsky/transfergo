//
//  TestHelper.swift
//  TransferGOTests
//
//  Created by Jan Gulkowski on 22/08/2023.
//

import Foundation

struct TestHelper {
    struct SomeStruct: Decodable {
        var someKey: String
    }
    
    static func getResponse(withStatusCode statusCode: Int) -> URLResponse {
        let url = URL(string: "https://some.random.url.com")!
        let httpURLResponse = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
        return httpURLResponse as URLResponse
    }
    
    static func getData() -> Data {
        let json = """
        {
            "someKey": "someValue"
        }
        """
        let data = Data(json.utf8)
        return data
    }
    
    static func getRate() -> Rate {
        let rate = 1.23456789
        let fromAmount = 300.0
        return Rate(
            from: "PLN",
            to: "UAH",
            rate: rate,
            fromAmount: fromAmount,
            toAmount: rate * fromAmount
        )
    }
}
