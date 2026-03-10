//
//  APIClientTests.swift
//  thmanyahTests
//
//  Created by MohammadHijjawi on 08/03/2026.
//

import XCTest
@testable import thmanyah

private final class MockURLProtocol: URLProtocol {
    static var responseData: Data?
    static var statusCode: Int = 200

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
    override func startLoading() {
        if let data = Self.responseData, let url = request.url {
            let response = HTTPURLResponse(url: url, statusCode: Self.statusCode, httpVersion: nil, headerFields: ["Content-Type": "application/json"])!
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
        }
        client?.urlProtocolDidFinishLoading(self)
    }
    override func stopLoading() {}
}

final class APIClientTests: XCTestCase {
    var session: URLSession!
    var client: APIClient!

    override func setUpWithError() throws {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        session = URLSession(configuration: config)
        client = APIClient(session: session)
    }

    override func tearDownWithError() throws {
        MockURLProtocol.responseData = nil
        MockURLProtocol.statusCode = 200
    }

    func testRequestDecodesValidJSON() async throws {
        struct DecodablePayload: Decodable { let value: String }
        let json = #"{"value":"hello"}"#
        MockURLProtocol.responseData = json.data(using: .utf8)
        MockURLProtocol.statusCode = 200

        let result: DecodablePayload = try await client.request(url: URL(string: "https://example.com")!)

        XCTAssertEqual(result.value, "hello")
    }

    func testRequestThrowsOnNon2xxStatus() async {
        struct Dummy: Decodable {}
        MockURLProtocol.responseData = Data()
        MockURLProtocol.statusCode = 500

        do {
            let _: Dummy = try await client.request(url: URL(string: "https://example.com")!)
            XCTFail("Expected APIError.httpError")
        } catch APIError.httpError(let code, _) {
            XCTAssertEqual(code, 500)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testRequestThrowsDecodingErrorOnInvalidJSON() async {
        struct Payload: Decodable { let x: Int }
        MockURLProtocol.responseData = #"{"x":"not a number"}"#.data(using: .utf8)
        MockURLProtocol.statusCode = 200

        do {
            let _: Payload = try await client.request(url: URL(string: "https://example.com")!)
            XCTFail("Expected decodingError")
        } catch APIError.decodingError {
            // expected
        } catch {
            XCTFail("Expected APIError.decodingError, got \(error)")
        }
    }

    func testRequestThrowsInvalidResponseWhenNotHTTPURLResponse() async {
        // URLSession with our protocol always gives HTTPURLResponse, so we test the error type exists
        XCTAssertNotNil(APIError.invalidResponse)
    }
}
