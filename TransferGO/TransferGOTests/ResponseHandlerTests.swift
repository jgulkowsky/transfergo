//
//  ResponseHandlerTests.swift
//  ResponseHandlerTests
//
//  Created by Jan Gulkowski on 14/08/2023.
//

import XCTest
@testable import TransferGO

final class ResponseHandlerTests: XCTestCase {
    private var responseHandler: ResponseHandler!
    private var mockDataDecoder: MockDataDecoder!
    
    override func setUp() {
        mockDataDecoder = MockDataDecoder()
        responseHandler = ResponseHandler(decoder: mockDataDecoder)
    }
    
    func test_handleResponse_whenResponseNil_itShouldThrowBadResponseError() {
        do {
            let _: String = try responseHandler.handleResponse(data: nil, response: nil)
            XCTFail("it should throw but it returned")
        } catch ResponseHandlerError.badResponse {
            XCTAssert(true)
        } catch {
            XCTFail("it threw but not proper error of ResponseHandlerError.badResponse type. It threw error: \(error)")
        }
    }
    
    func test_handleResponse_whenResponseBelow200_itShouldThrowBadResponseError() {
        do {
            let response = getResponse(withStatusCode: 101)
            let _: SomeStruct = try responseHandler.handleResponse(data: nil, response: response)
            XCTFail("it should throw but it returned")
        } catch ResponseHandlerError.badResponse {
            XCTAssert(true)
        } catch {
            XCTFail("it threw but not proper error of ResponseHandlerError.badResponse type. It threw error: \(error)")
        }
    }
    
    func test_handleResponse_whenResponseOver299_itShouldThrowBadResponseError() {
        do {
            let response = getResponse(withStatusCode: 304)
            let _: SomeStruct = try responseHandler.handleResponse(data: nil, response: response)
            XCTFail("it should throw but it returned")
        } catch ResponseHandlerError.badResponse {
            XCTAssert(true)
        } catch {
            XCTFail("it threw but not proper error of ResponseHandlerError.badResponse type. It threw error: \(error)")
        }
    }
    
    func test_handleResponse_whenResponseInRangeOf200To299_andDataIsNil_itShouldThrowNoDataError() {
        do {
            let response = getResponse(withStatusCode: Int.random(in: 200...299))
            let _: SomeStruct = try responseHandler.handleResponse(data: nil, response: response)
            XCTFail("it should throw but it returned")
        } catch ResponseHandlerError.noData {
            XCTAssert(true)
        } catch {
            XCTFail("it threw but not proper error of ResponseHandlerError.noData type. It threw error: \(error)")
        }
    }
    
    func test_handleResponse_whenResponseInRangeOf200To299_andDataIsNotNil_andDecoderThrows_itShouldThrowAfterDecoder() {
        do {
            mockDataDecoder = MockDataDecoder(shouldThrow: true)
            responseHandler = ResponseHandler(decoder: mockDataDecoder)
            let data = getData()
            let response = getResponse(withStatusCode: 200)
            let _: SomeStruct = try responseHandler.handleResponse(data: data, response: response)
            XCTFail("it should throw but it returned")
        } catch {
            XCTAssert(true)
        }
    }
    
    func test_handleResponse_whenResponseInRangeOf200To299_andDataIsNotNil_andDecoderDoesntThrow_itShouldReturnWhatDecoderReturns() {
        do {
            let data = getData()
            let response = getResponse(withStatusCode: 200)
            let _: SomeStruct = try responseHandler.handleResponse(data: data, response: response)
            XCTAssert(true)
        } catch {
            XCTFail("it should not throw but return value. Error thrown is: \(error)")
        }
    }
}

private extension ResponseHandlerTests {
    struct SomeStruct: Decodable {
        var someKey: String
    }
    
    func getResponse(withStatusCode statusCode: Int) -> URLResponse {
        let url = URL(string: "https://some.random.url.com")!
        let httpURLResponse = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
        return httpURLResponse as URLResponse
    }
    
    func getData() -> Data {
        let json = """
        {
            "someKey": "someValue"
        }
        """
        let data = Data(json.utf8)
        return data
    }
}
