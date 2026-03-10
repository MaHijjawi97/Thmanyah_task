//
//  FetchHomeSectionsUseCase.swift
//  thmanyah
//
//  Created by MohammadHijjawi on 08/03/2026.
//


import Foundation

struct FetchHomeSectionsUseCase {
    private let repository: HomeRepositoryProtocol

    init(repository: HomeRepositoryProtocol) {
        self.repository = repository
    }

    func execute(page: Int = 1) async throws -> (sections: [Section], nextPage: Int?) {
        try await repository.fetchSections(page: page)
    }
}
