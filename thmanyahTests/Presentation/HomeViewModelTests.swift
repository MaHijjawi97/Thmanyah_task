//
//  HomeViewModelTests.swift
//  thmanyahTests
//
//  Created by MohammadHijjawi on 08/03/2026.
//

import XCTest
@testable import thmanyah

@MainActor
final class HomeViewModelTests: XCTestCase {
    var mockRepo: MockHomeRepository!
    var useCase: FetchHomeSectionsUseCase!
    var viewModel: HomeViewModel!

    override func setUpWithError() throws {
        mockRepo = MockHomeRepository()
        useCase = FetchHomeSectionsUseCase(repository: mockRepo)
        viewModel = HomeViewModel(fetchSectionsUseCase: useCase)
    }

    func testInitialStateIsIdle() {
        XCTAssertEqual(viewModel.viewState, .idle)
        XCTAssertTrue(viewModel.sections.isEmpty)
    }

    func testLoadDataSetsSectionsWhenSuccess() async {
        let section = Section(
            name: "Top",
            layoutType: .square,
            contentType: .podcast,
            order: 1,
            items: []
        )
        mockRepo.result = .success(([section], nil))

        await viewModel.loadData()

        XCTAssertEqual(viewModel.viewState, .loaded)
        XCTAssertEqual(viewModel.sections.count, 1)
        XCTAssertEqual(viewModel.sections.first?.name, "Top")
    }

    func testLoadDataSetsErrorWhenFailure() async {
        mockRepo.result = .failure(NSError(domain: "test", code: -1, userInfo: [NSLocalizedDescriptionKey: "Network error"]))

        await viewModel.loadData()

        if case .error(let message) = viewModel.viewState {
            XCTAssertFalse(message.isEmpty)
        } else {
            XCTFail("Expected error state")
        }
    }

    func testRetryCallsLoadData() async {
        mockRepo.result = .success(([], nil))
        await viewModel.loadData()
        let callCountAfterLoad = mockRepo.fetchCallCount

        await viewModel.retry()

        XCTAssertEqual(mockRepo.fetchCallCount, callCountAfterLoad + 1)
    }
}
