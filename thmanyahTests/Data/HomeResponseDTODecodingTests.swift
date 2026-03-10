//
//  HomeResponseDTODecodingTests.swift
//  thmanyahTests
//
//  Created by MohammadHijjawi on 08/03/2026.
//

import XCTest
@testable import thmanyah

final class HomeResponseDTODecodingTests: XCTestCase {
    func testDecodeHomeResponseWithPodcastSection() throws {
        let json = """
        {
            "sections": [{
                "name": "Top Podcasts",
                "type": "square",
                "content_type": "podcast",
                "order": 1,
                "content": [{
                    "podcast_id": "123",
                    "name": "Test Show",
                    "description": "A test",
                    "avatar_url": "https://example.com/img.png",
                    "episode_count": 10,
                    "duration": 3600
                }]
            }],
            "pagination": { "next_page": "/home_sections?page=2", "total_pages": 10 }
        }
        """
        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        let response = try decoder.decode(HomeResponseDTO.self, from: data)

        XCTAssertEqual(response.sections.count, 1)
        XCTAssertEqual(response.sections[0].name, "Top Podcasts")
        XCTAssertEqual(response.sections[0].type, "square")
        XCTAssertEqual(response.sections[0].contentType, "podcast")
        XCTAssertEqual(response.sections[0].content.count, 1)
        XCTAssertEqual(response.sections[0].content[0].name, "Test Show")
        XCTAssertEqual(response.sections[0].content[0].podcastId, "123")
        XCTAssertEqual(response.pagination?.nextPage, "/home_sections?page=2")
    }

    func testDecodeSectionWithStringOrderAndStringNumbers() throws {
        let json = """
        {
            "sections": [{
                "name": "S",
                "type": "square",
                "content_type": "podcast",
                "order": "42",
                "content": [{
                    "podcast_id": "p1",
                    "name": "Show",
                    "episode_count": "10",
                    "duration": "3600",
                    "priority": "1",
                    "popularityScore": "100",
                    "score": "4.5"
                }]
            }]
        }
        """
        let response = try JSONDecoder().decode(HomeResponseDTO.self, from: json.data(using: .utf8)!)
        XCTAssertEqual(response.sections[0].order, 42)
        let item = response.sections[0].content[0]
        XCTAssertEqual(item.episodeCount, 10)
        XCTAssertEqual(item.duration, 3600)
        XCTAssertEqual(item.priority, 1)
        XCTAssertEqual(item.score, 4.5)
    }
}
