//
//  SearchContentUseCaseTests.swift
//  thmanyahTests
//
//  Created by MohammadHijjawi on 08/03/2026.
//

import XCTest
@testable import thmanyah

final class SearchContentUseCaseTests: XCTestCase {
    var mockRepo: MockSearchRepository!
    var useCase: SearchContentUseCase!

    override func setUpWithError() throws {
        mockRepo = MockSearchRepository()
        useCase = SearchContentUseCase(repository: mockRepo)
    }

    func testExecuteReturnsSectionsFromRepository() async throws {
        let section = Section(
            name: "Results",
            layoutType: .square,
            contentType: .podcast,
            order: 1,
            items: []
        )
        mockRepo.result = .success([section])

        let sections = try await useCase.execute(query: "test")

        XCTAssertEqual(sections.count, 1)
        XCTAssertEqual(sections.first?.name, "Results")
        XCTAssertEqual(mockRepo.searchCallCount, 1)
        XCTAssertEqual(mockRepo.lastQuery, "test")
    }

    func testExecuteThrowsWhenRepositoryFails() async {
        mockRepo.result = .failure(NSError(domain: "test", code: -1, userInfo: nil))

        do {
            _ = try await useCase.execute(query: "q")
            XCTFail("Expected throw")
        } catch {
            XCTAssertEqual(mockRepo.searchCallCount, 1)
        }
    }
}
