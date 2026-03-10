//
//  Section.swift
//  thmanyah
//
//  Created by MohammadHijjawi on 08/03/2026.
//

import Foundation

struct Section: Sendable {
    let name: String
    let layoutType: LayoutType
    let contentType: ContentType
    let order: Int
    let items: [SectionItem]
}
