//
//  DefaultSearchRepository.swift
//  thmanyah
//
//  Created by MohammadHijjawi on 08/03/2026.
//

import Foundation

final class DefaultSearchRepository: SearchRepositoryProtocol, Sendable {
    private let searchAPI: SearchAPI

    init(apiClient: APIClientProtocol) {
        self.searchAPI = SearchAPI(apiClient: apiClient)
    }

    func search(query: String) async throws -> [Section] {
        let response = try await searchAPI.search(query: query)
        let mapped = SectionMapper.map(response.sections)
        // For search results, we force a vertical list layout (.twoLinesGrid)
        // to ensure they are readable, as the mock API returns random layout types.
        let forcedLayout = mapped.map { section in
            Section(
                name: section.name,
                layoutType: .twoLinesGrid,
                contentType: section.contentType,
                order: section.order,
                items: section.items
            )
        }
        
        #if DEBUG
        debugPrint("[Search] DTO sections.count=\(response.sections.count) → mapped sections.count=\(mapped.count)")
        #endif
        return forcedLayout
    }
}
