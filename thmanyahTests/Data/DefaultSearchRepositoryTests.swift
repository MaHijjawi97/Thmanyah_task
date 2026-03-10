//
//  DefaultSearchRepositoryTests.swift
//  thmanyahTests
//
//  Created by MohammadHijjawi on 08/03/2026.
//

import XCTest
@testable import thmanyah

final class DefaultSearchRepositoryTests: XCTestCase {
    var mockClient: MockAPIClient!
    var repository: DefaultSearchRepository!

    override func setUpWithError() throws {
        mockClient = MockAPIClient()
        repository = DefaultSearchRepository(apiClient: mockClient)
    }

    func testSearchReturnsMappedSections() async throws {
        let json = """
        {
            "sections": [{
                "name": "Results",
                "type": "square",
                "content_type": "podcast",
                "order": 1,
                "content": [{
                    "podcast_id": "p1",
                    "name": "Show One",
                    "avatar_url": "https://example.com/a.png",
                    "episode_count": 10
                }]
            }]
        }
        """
        mockClient.responseData = json.data(using: .utf8)

        let sections = try await repository.search(query: "test")

        XCTAssertEqual(sections.count, 1)
        XCTAssertEqual(sections[0].name, "Results")
        XCTAssertEqual(sections[0].layoutType, .square)
        XCTAssertEqual(sections[0].contentType, .podcast)
        XCTAssertEqual(sections[0].items.count, 1)
        XCTAssertEqual(sections[0].items[0].title, "Show One")
    }

    func testSearchWithUnknownTypeUsesFallbackLayoutAndContentType() async throws {
        let json = """
        {
            "sections": [{
                "name": "U",
                "type": "unknown_layout",
                "content_type": "unknown_content",
                "order": "non-numeric",
                "content": [{ "podcast_id": "p1", "name": "Item" }]
            }]
        }
        """
        mockClient.responseData = json.data(using: .utf8)

        let sections = try await repository.search(query: "q")

        XCTAssertEqual(sections.count, 1)
        XCTAssertEqual(sections[0].layoutType, .square)
        XCTAssertEqual(sections[0].contentType, .podcast)
        XCTAssertEqual(sections[0].items.count, 1)
    }

    func testSearchThrowsWhenAPIThrows() async {
        mockClient.errorToThrow = APIError.httpError(statusCode: 500, data: nil)

        do {
            _ = try await repository.search(query: "q")
            XCTFail("Expected throw")
        } catch APIError.httpError(let code, _) {
            XCTAssertEqual(code, 500)
        } catch {
            XCTFail("Expected APIError.httpError, got \(error)")
        }
    }
}
