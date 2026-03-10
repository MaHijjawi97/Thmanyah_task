//
//  SectionMapper.swift
//  thmanyah
//
//  Created by MohammadHijjawi on 08/03/2026.
//
import Foundation

enum SectionMapper {
    static func map(_ dto: SectionDTO) -> Section? {
        // Use fallbacks for unknown API values (e.g. mock search returns random strings).
        let layoutType = LayoutType(rawValue: dto.type) ?? .square
        let contentType = ContentType(rawValue: dto.contentType) ?? .podcast
        let items = dto.content.compactMap { SectionItemMapper.map($0, contentType: contentType) }
        return Section(
            name: dto.name,
            layoutType: layoutType,
            contentType: contentType,
            order: dto.order,
            items: items
        )
    }

    static func map(_ dtos: [SectionDTO]) -> [Section] {
        dtos.compactMap { map($0) }
    }
}

enum SectionItemMapper {
    static func map(_ dto: SectionItemDTO, contentType: ContentType) -> SectionItem? {
        let audioURL = dto.audioURL
        let videoURL = dto.videoURL
        // Use a fresh UUID for each mapped item so that duplicate
        // content entries from the API (same underlying id) still
        // appear as separate rows/cards in SwiftUI ForEach.
        let uniqueId = UUID().uuidString
        switch contentType {
        case .podcast:
            return .podcast(
                id: uniqueId,
                name: dto.name,
                description: dto.description,
                avatarURL: dto.imageURL,
                episodeCount: dto.episodeCount,
                duration: dto.duration,
                audioURL: audioURL,
                videoURL: videoURL
            )
        case .episode:
            return .episode(
                id: uniqueId,
                name: dto.name,
                podcastName: dto.podcastName,
                avatarURL: dto.imageURL,
                duration: dto.duration,
                audioURL: audioURL,
                videoURL: videoURL
            )
        case .audioBook:
            return .audiobook(
                id: uniqueId,
                name: dto.name,
                authorName: dto.authorName,
                avatarURL: dto.imageURL,
                duration: dto.duration,
                audioURL: audioURL,
                videoURL: videoURL
            )
        case .audioArticle:
            return .article(
                id: uniqueId,
                name: dto.name,
                authorName: dto.authorName,
                avatarURL: dto.imageURL,
                duration: dto.duration,
                audioURL: audioURL,
                videoURL: videoURL
            )
        }
    }
}
