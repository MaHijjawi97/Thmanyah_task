//
//  MockHomeRepository.swift
//  thmanyahTests
//
//  Created by MohammadHijjawi on 08/03/2026.
//


import Foundation
@testable import thmanyah

final class MockHomeRepository: HomeRepositoryProtocol, @unchecked Sendable {
    var result: Result<(sections: [Section], nextPage: Int?), Error> = .success(([], nil))
    var fetchCallCount = 0
    var lastPage: Int?

    func fetchSections(page: Int) async throws -> (sections: [Section], nextPage: Int?) {
        fetchCallCount += 1
        lastPage = page
        switch result {
        case .success(let value): return value
        case .failure(let error): throw error
        }
    }
}
