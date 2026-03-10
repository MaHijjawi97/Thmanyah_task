//
//  thmanyahTests.swift
//  thmanyahTests
//
//  Created by MohammadHijjawi on 08/03/2026.
//

import XCTest
@testable import thmanyah

final class thmanyahTests: XCTestCase {
    func testSectionMapperMapsSquareSection() throws {
        let json = """
        {"name":"Test","type":"square","content_type":"podcast","order":1,"content":[]}
        """
        let dto = try JSONDecoder().decode(SectionDTO.self, from: json.data(using: .utf8)!)
        let section = SectionMapper.map(dto)
        XCTAssertNotNil(section)
        XCTAssertEqual(section?.name, "Test")
        XCTAssertEqual(section?.layoutType, .square)
        XCTAssertEqual(section?.contentType, .podcast)
    }

    func testLayoutTypeNormalizesBigSquareWithSpace() {
        let layout = LayoutType(rawValue: "big square")
        XCTAssertEqual(layout, .bigSquare)
    }

    func testSectionMapperUsesFallbackForUnknownTypeAndContentType() throws {
        let json = """
        {"name":"Search Results","type":"unknown_type","content_type":"unknown_content","order":"nope","content":[{"podcast_id":"p1","name":"Item"}]}
        """
        let dto = try JSONDecoder().decode(SectionDTO.self, from: json.data(using: .utf8)!)
        let section = SectionMapper.map(dto)
        XCTAssertNotNil(section)
        XCTAssertEqual(section?.name, "Search Results")
        XCTAssertEqual(section?.layoutType, .square)
        XCTAssertEqual(section?.contentType, .podcast)
        XCTAssertEqual(section?.order, 0)
        XCTAssertEqual(section?.items.count, 1)
    }

    func testSectionMapperMapsAllContentTypes() throws {
        let json = """
        {"name":"Mixed","type":"2_lines_grid","content_type":"episode","order":1,"content":[{"episode_id":"e1","name":"Ep","podcast_name":"Show"}]}
        """
        let dto = try JSONDecoder().decode(SectionDTO.self, from: json.data(using: .utf8)!)
        let section = SectionMapper.map(dto)
        XCTAssertEqual(section?.contentType, .episode)
        XCTAssertEqual(section?.items.first?.contentType, .episode)
    }

    func testSectionItemHasPlayableMedia() {
        let withAudio = SectionItem.podcast(id: "1", name: "P", description: nil, avatarURL: nil, episodeCount: nil, duration: nil, audioURL: URL(string: "https://a.com")!, videoURL: nil)
        XCTAssertTrue(withAudio.hasPlayableMedia)
        let without = SectionItem.podcast(id: "2", name: "P", description: nil, avatarURL: nil, episodeCount: nil, duration: nil, audioURL: nil, videoURL: nil)
        XCTAssertFalse(without.hasPlayableMedia)
    }
}
