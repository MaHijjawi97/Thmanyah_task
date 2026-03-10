//
//  FetchHomeSectionsUseCaseTests.swift
//  thmanyahTests
//
//  Created by MohammadHijjawi on 08/03/2026.
//

import XCTest
@testable import thmanyah

final class FetchHomeSectionsUseCaseTests: XCTestCase {
    var mockRepo: MockHomeRepository!
    var useCase: FetchHomeSectionsUseCase!

    override func setUpWithError() throws {
        mockRepo = MockHomeRepository()
        useCase = FetchHomeSectionsUseCase(repository: mockRepo)
    }

    func testExecuteReturnsSectionsFromRepository() async throws {
        let section = Section(
            name: "Test",
            layoutType: .square,
            contentType: .podcast,
            order: 1,
            items: []
        )
        mockRepo.result = .success(([section], 2))

        let (sections, nextPage) = try await useCase.execute(page: 1)

        XCTAssertEqual(sections.count, 1)
        XCTAssertEqual(sections.first?.name, "Test")
        XCTAssertEqual(nextPage, 2)
        XCTAssertEqual(mockRepo.fetchCallCount, 1)
        XCTAssertEqual(mockRepo.lastPage, 1)
    }

    func testExecuteThrowsWhenRepositoryFails() async {
        mockRepo.result = .failure(NSError(domain: "test", code: -1, userInfo: nil))

        do {
            _ = try await useCase.execute(page: 1)
            XCTFail("Expected throw")
        } catch {
            XCTAssertEqual(mockRepo.fetchCallCount, 1)
        }
    }
}
