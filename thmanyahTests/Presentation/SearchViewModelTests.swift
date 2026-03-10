//
//  SearchViewModelTests.swift
//  thmanyahTests
//
//  Created by MohammadHijjawi on 08/03/2026.
//

import XCTest
@testable import thmanyah

@MainActor
final class SearchViewModelTests: XCTestCase {
    var mockRepo: MockSearchRepository!
    var useCase: SearchContentUseCase!
    var viewModel: SearchViewModel!

    override func setUpWithError() throws {
        mockRepo = MockSearchRepository()
        useCase = SearchContentUseCase(repository: mockRepo)
        viewModel = SearchViewModel(searchUseCase: useCase)
    }

    func testInitialStateIsEmpty() {
        XCTAssertTrue(viewModel.sections.isEmpty)
        XCTAssertFalse(viewModel.isSearching)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.searchText, "")
    }

    func testSearchTextChangedWithEmptyClearsSections() {
        mockRepo.result = .success([Section(name: "X", layoutType: .square, contentType: .podcast, order: 0, items: [])])
        viewModel.searchTextChanged("test")
        // After debounce we'd get sections; first set to empty query
        viewModel.searchTextChanged("")
        XCTAssertEqual(viewModel.searchText, "")
        XCTAssertTrue(viewModel.sections.isEmpty)
        XCTAssertNil(viewModel.errorMessage)
    }

    func testSearchTextChangedWithQueryEventuallyFillsSections() async {
        let section = Section(
            name: "Results",
            layoutType: .square,
            contentType: .podcast,
            order: 1,
            items: []
        )
        mockRepo.result = .success([section])

        viewModel.searchTextChanged("test")
        try? await Task.sleep(nanoseconds: 250_000_000)

        XCTAssertEqual(viewModel.sections.count, 1)
        XCTAssertEqual(viewModel.sections.first?.name, "Results")
        XCTAssertEqual(mockRepo.lastQuery, "test")
    }

    func testSearchFailureSetsErrorMessage() async {
        mockRepo.result = .failure(NSError(domain: "test", code: -1, userInfo: [NSLocalizedDescriptionKey: "Network failed"]))

        viewModel.searchTextChanged("q")
        try? await Task.sleep(nanoseconds: 250_000_000)

        XCTAssertFalse(viewModel.errorMessage?.isEmpty ?? true)
        XCTAssertTrue(viewModel.sections.isEmpty)
    }
}
