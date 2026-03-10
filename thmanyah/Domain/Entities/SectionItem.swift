//
//  SectionItem.swift
//  thmanyah
//
//  Created by MohammadHijjawi on 08/03/2026.
//

import Foundation

struct SectionItem: Sendable {
    let id: String
    let title: String
    let subtitle: String?
    let imageURL: URL?
    let durationSeconds: Int?
    let contentType: ContentType
    let episodeCount: Int?
    let authorName: String?
    /// Playable audio URL when API provides it (e.g. episodes).
    let audioURL: URL?
    /// Optional video URL when API provides it for dual audio/video content.
    let videoURL: URL?

    var hasPlayableMedia: Bool { audioURL != nil || videoURL != nil }

    static func podcast(id: String, name: String, description: String?, avatarURL: URL?, episodeCount: Int?, duration: Int?, audioURL: URL? = nil, videoURL: URL? = nil) -> SectionItem {
        SectionItem(
            id: id,
            title: name,
            subtitle: description,
            imageURL: avatarURL,
            durationSeconds: duration,
            contentType: .podcast,
            episodeCount: episodeCount,
            authorName: nil,
            audioURL: audioURL,
            videoURL: videoURL
        )
    }

    static func episode(id: String, name: String, podcastName: String?, avatarURL: URL?, duration: Int?, audioURL: URL? = nil, videoURL: URL? = nil) -> SectionItem {
        SectionItem(
            id: id,
            title: name,
            subtitle: podcastName,
            imageURL: avatarURL,
            durationSeconds: duration,
            contentType: .episode,
            episodeCount: nil,
            authorName: nil,
            audioURL: audioURL,
            videoURL: videoURL
        )
    }

    static func audiobook(id: String, name: String, authorName: String?, avatarURL: URL?, duration: Int?, audioURL: URL? = nil, videoURL: URL? = nil) -> SectionItem {
        SectionItem(
            id: id,
            title: name,
            subtitle: nil,
            imageURL: avatarURL,
            durationSeconds: duration,
            contentType: .audioBook,
            episodeCount: nil,
            authorName: authorName,
            audioURL: audioURL,
            videoURL: videoURL
        )
    }

    static func article(id: String, name: String, authorName: String?, avatarURL: URL?, duration: Int?, audioURL: URL? = nil, videoURL: URL? = nil) -> SectionItem {
        SectionItem(
            id: id,
            title: name,
            subtitle: nil,
            imageURL: avatarURL,
            durationSeconds: duration,
            contentType: .audioArticle,
            episodeCount: nil,
            authorName: authorName,
            audioURL: audioURL,
            videoURL: videoURL
        )
    }
}
