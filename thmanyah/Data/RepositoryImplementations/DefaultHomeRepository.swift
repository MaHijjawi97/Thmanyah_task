//
//  DefaultHomeRepository.swift
//  thmanyah
//
//  Created by MohammadHijjawi on 08/03/2026.
//

import Foundation

final class DefaultHomeRepository: HomeRepositoryProtocol, Sendable {
    private let homeAPI: HomeAPI

    init(apiClient: APIClientProtocol) {
        self.homeAPI = HomeAPI(apiClient: apiClient)
    }

    func fetchSections(page: Int) async throws -> (sections: [Section], nextPage: Int?) {
        let response = try await homeAPI.fetchHomeSections(page: page)
        let sections = SectionMapper.map(response.sections)
        var nextPage: Int? = nil
        if let next = response.pagination?.nextPage, next.contains("page=") {
            if let value = next.split(separator: "=").last.flatMap({ Int($0) }) {
                nextPage = value
            }
        }
        return (sections, nextPage)
    }
}
