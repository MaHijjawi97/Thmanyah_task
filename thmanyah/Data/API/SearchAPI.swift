//
//  SearchAPI.swift
//  thmanyah
//
//  Created by MohammadHijjawi on 09/03/2026.
//

import Foundation

/// Search API returns same shape as home (sections with content).
struct SearchResponseDTO: Decodable {
    let sections: [SectionDTO]
}

struct SearchAPI {
    let apiClient: APIClientProtocol

    func search(query: String) async throws -> SearchResponseDTO {
        let url = Endpoint.search(query: query)
        return try await apiClient.request(url: url)
    }
}
