//
//  HomeResponseDTO.swift
//  thmanyah
//
//  Created by MohammadHijjawi on 09/03/2026.
//  DTOs matching the home_sections API response. Content items use optional fields
//  to support podcast, episode, audiobook, and audio_article shapes.
//

import Foundation

struct HomeResponseDTO: Decodable {
    let sections: [SectionDTO]
    let pagination: PaginationDTO?
}

struct PaginationDTO: Decodable {
    let nextPage: String?
    let totalPages: Int?

    enum CodingKeys: String, CodingKey {
        case nextPage = "next_page"
        case totalPages = "total_pages"
    }
}

struct SectionDTO: Decodable {
    let name: String
    let type: String
    let contentType: String
    /// Order from API; may be Int (home) or String (search mock).
    let order: Int
    let content: [SectionItemDTO]

    enum CodingKeys: String, CodingKey {
        case name, type, content, order
        case contentType = "content_type"
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        name = try c.decode(String.self, forKey: .name)
        type = try c.decode(String.self, forKey: .type)
        contentType = try c.decode(String.self, forKey: .contentType)
        if let intOrder = try? c.decode(Int.self, forKey: .order) {
            order = intOrder
        } else if let strOrder = try? c.decode(String.self, forKey: .order), let intOrder = Int(strOrder) {
            order = intOrder
        } else {
            order = 0
        }
        content = try c.decode([SectionItemDTO].self, forKey: .content)
    }
}

/// Single DTO for all content item types; API uses different keys per type.
struct SectionItemDTO: Decodable {
    // Podcast
    var podcastId: String?
    var episodeCount: Int?
    var priority: Int?
    var popularityScore: String?
    var score: Double?

    // Episode
    var episodeId: String?
    var podcastName: String?
    var authorName: String?
    var releaseDate: String?
    var audioUrl: String?
    var videoUrl: String?

    // Audiobook / Article
    var audiobookId: String?
    var articleId: String?

    // Common
    var name: String
    var description: String?
    var avatarUrl: String?
    var duration: Int?
    var language: String?

    enum CodingKeys: String, CodingKey {
        case name, description, duration, language
        case podcastId = "podcast_id"
        case episodeId = "episode_id"
        case episodeCount = "episode_count"
        case priority
        case popularityScore = "popularityScore"
        case score
        case podcastName = "podcast_name"
        case authorName = "author_name"
        case releaseDate = "release_date"
        case audioUrl = "audio_url"
        case videoUrl = "video_url"
        case avatarUrl = "avatar_url"
        case audiobookId = "audiobook_id"
        case articleId = "article_id"
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        name = try c.decode(String.self, forKey: .name)
        description = try c.decodeIfPresent(String.self, forKey: .description)
        avatarUrl = try c.decodeIfPresent(String.self, forKey: .avatarUrl)
        duration = Self.decodeIntOrString(c, forKey: .duration)
        language = try c.decodeIfPresent(String.self, forKey: .language)
        podcastId = try c.decodeIfPresent(String.self, forKey: .podcastId)
        episodeCount = Self.decodeIntOrString(c, forKey: .episodeCount)
        priority = Self.decodeIntOrString(c, forKey: .priority)
        if let i = try? c.decodeIfPresent(Int.self, forKey: .popularityScore) {
            popularityScore = String(i)
        } else {
            popularityScore = try c.decodeIfPresent(String.self, forKey: .popularityScore)
        }
        score = Self.decodeDoubleOrString(c, forKey: .score)
        episodeId = try c.decodeIfPresent(String.self, forKey: .episodeId)
        podcastName = try c.decodeIfPresent(String.self, forKey: .podcastName)
        authorName = try c.decodeIfPresent(String.self, forKey: .authorName)
        releaseDate = try c.decodeIfPresent(String.self, forKey: .releaseDate)
        audioUrl = try c.decodeIfPresent(String.self, forKey: .audioUrl)
        videoUrl = try c.decodeIfPresent(String.self, forKey: .videoUrl)
        audiobookId = try c.decodeIfPresent(String.self, forKey: .audiobookId)
        articleId = try c.decodeIfPresent(String.self, forKey: .articleId)
    }

    /// Decode Int when API sends number or string (e.g. search mock).
    private static func decodeIntOrString(_ c: KeyedDecodingContainer<SectionItemDTO.CodingKeys>, forKey key: SectionItemDTO.CodingKeys) -> Int? {
        if let i = try? c.decodeIfPresent(Int.self, forKey: key) { return i }
        if let s = try? c.decodeIfPresent(String.self, forKey: key) { return Int(s) }
        return nil
    }

    /// Decode Double when API sends number or string (e.g. search mock).
    private static func decodeDoubleOrString(_ c: KeyedDecodingContainer<SectionItemDTO.CodingKeys>, forKey key: SectionItemDTO.CodingKeys) -> Double? {
        if let d = try? c.decodeIfPresent(Double.self, forKey: key) { return d }
        if let s = try? c.decodeIfPresent(String.self, forKey: key) { return Double(s) }
        return nil
    }

    var id: String {
        episodeId ?? podcastId ?? audiobookId ?? articleId ?? UUID().uuidString
    }

    var imageURL: URL? {
        guard let s = avatarUrl, let u = URL(string: s) else { return nil }
        return u
    }

    var audioURL: URL? {
        guard let s = audioUrl, let u = URL(string: s) else { return nil }
        return u
    }

    var videoURL: URL? {
        guard let s = videoUrl, let u = URL(string: s) else { return nil }
        return u
    }
}
