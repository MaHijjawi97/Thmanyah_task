//
//  SearchAPITests.swift
//  thmanyahTests
//
//  Created by MohammadHijjawi on 08/03/2026.
//

import XCTest
@testable import thmanyah

final class SearchAPITests: XCTestCase {
    var mockClient: MockAPIClient!
    var searchAPI: SearchAPI!

    override func setUpWithError() throws {
        mockClient = MockAPIClient()
        searchAPI = SearchAPI(apiClient: mockClient)
    }

    func testSearchBuildsCorrectURLAndReturnsDecodedResponse() async throws {
        let json = """
        { "sections": [{ "name": "Results", "type": "square", "content_type": "podcast", "order": 1, "content": [] }] }
        """
        mockClient.responseData = json.data(using: .utf8)

        let response = try await searchAPI.search(query: "test")

        XCTAssertEqual(response.sections.count, 1)
        XCTAssertEqual(response.sections[0].name, "Results")
        XCTAssertTrue(mockClient.lastURL?.absoluteString.contains("search") == true)
        XCTAssertTrue(mockClient.lastURL?.absoluteString.contains("q=test") == true)
    }

    func testSearchThrowsWhenClientThrows() async {
        mockClient.errorToThrow = NSError(domain: "test", code: -1, userInfo: nil)

        do {
            _ = try await searchAPI.search(query: "x")
            XCTFail("Expected throw")
        } catch {
            XCTAssertEqual((error as NSError).domain, "test")
        }
    }
}
