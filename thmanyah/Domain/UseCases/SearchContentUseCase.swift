//
//  SearchContentUseCase.swift
//  thmanyah
//
//  Created by MohammadHijjawi on 08/03/2026.
//

import Foundation

struct SearchContentUseCase {
    private let repository: SearchRepositoryProtocol

    init(repository: SearchRepositoryProtocol) {
        self.repository = repository
    }

    func execute(query: String) async throws -> [Section] {
        try await repository.search(query: query)
    }
}
