//
//  MockSearchRepository.swift
//  thmanyahTests
//
//  Created by MohammadHijjawi on 08/03/2026.
//

import Foundation
@testable import thmanyah

final class MockSearchRepository: SearchRepositoryProtocol, @unchecked Sendable {
    var result: Result<[Section], Error> = .success([])
    var searchCallCount = 0
    var lastQuery: String?

    func search(query: String) async throws -> [Section] {
        searchCallCount += 1
        lastQuery = query
        switch result {
        case .success(let value): return value
        case .failure(let error): throw error
        }
    }
}
