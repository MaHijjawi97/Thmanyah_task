//
//  SearchResponseDTODecodingTests.swift
//  thmanyahTests
//
//  Created by MohammadHijjawi on 08/03/2026.
//

import XCTest
@testable import thmanyah

final class SearchResponseDTODecodingTests: XCTestCase {
    func testDecodeSearchResponseWithStringOrderAndStringNumbers() throws {
        let json = """
        {
            "sections": [{
                "name": "U",
                "type": "sed ut commodo velit",
                "content_type": "qui eu dolor in",
                "order": "tempor",
                "content": [{
                    "podcast_id": "53904ec7-2bbf-4fde-ba5a-d7a2c4409995",
                    "name": "Handmade Frozen Hat",
                    "description": "The Football Is Good",
                    "avatar_url": "https://avatars.githubusercontent.com/u/43593236",
                    "episode_count": "51",
                    "duration": "97505",
                    "language": "en",
                    "priority": "ullamco",
                    "popularityScore": "culpa",
                    "score": "ipsum"
                }]
            }]
        }
        """
        let data = json.data(using: .utf8)!
        let response = try JSONDecoder().decode(SearchResponseDTO.self, from: data)

        XCTAssertEqual(response.sections.count, 1)
        let section = response.sections[0]
        XCTAssertEqual(section.name, "U")
        XCTAssertEqual(section.order, 0)
        XCTAssertEqual(section.content.count, 1)
        let item = section.content[0]
        XCTAssertEqual(item.name, "Handmade Frozen Hat")
        XCTAssertEqual(item.podcastId, "53904ec7-2bbf-4fde-ba5a-d7a2c4409995")
        XCTAssertEqual(item.episodeCount, 51)
        XCTAssertEqual(item.duration, 97505)
    }

    func testDecodeSearchResponseWithIntegerOrder() throws {
        let json = """
        { "sections": [{ "name": "S", "type": "square", "content_type": "podcast", "order": 2, "content": [] }] }
        """
        let response = try JSONDecoder().decode(SearchResponseDTO.self, from: json.data(using: .utf8)!)
        XCTAssertEqual(response.sections[0].order, 2)
    }
}
