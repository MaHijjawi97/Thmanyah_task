//
//  ContentType.swift
//  thmanyah
//
//  Created by MohammadHijjawi on 08/03/2026.
//


import Foundation

enum ContentType: String, Codable, Sendable {
    case podcast
    case episode
    case audioBook = "audio_book"
    case audioArticle = "audio_article"

    init?(rawValue: String) {
        switch rawValue.lowercased() {
        case "podcast": self = .podcast
        case "episode": self = .episode
        case "audio_book": self = .audioBook
        case "audio_article": self = .audioArticle
        default: return nil
        }
    }
}
