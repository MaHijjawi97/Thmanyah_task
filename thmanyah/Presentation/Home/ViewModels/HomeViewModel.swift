//
//  HomeViewModel.swift
//  thmanyah
//
//  Created by MohammadHijjawi on 08/03/2026.
//


import Foundation
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    enum ViewState: Equatable {
        case idle
        case loading
        case loaded
        case error(String)
    }

    @Published private(set) var sections: [Section] = []
    @Published private(set) var viewState: ViewState = .idle
    @Published private(set) var isLoadingMore = false

    private let fetchSectionsUseCase: FetchHomeSectionsUseCase
    private var currentPage = 1
    private var nextPage: Int?

    init(fetchSectionsUseCase: FetchHomeSectionsUseCase) {
        self.fetchSectionsUseCase = fetchSectionsUseCase
    }

    func loadData() async {
        guard viewState != .loading else { return }
        viewState = .loading
        currentPage = 1
        sections = []
        nextPage = nil

        do {
            let result = try await fetchSectionsUseCase.execute(page: 1)
            sections = result.sections
            nextPage = result.nextPage
            viewState = .loaded
        } catch {
            viewState = .error(error.localizedDescription)
        }
    }

    func loadMoreIfNeeded() async {
        guard let next = nextPage, !isLoadingMore else { return }
        isLoadingMore = true
        defer { isLoadingMore = false }

        do {
            let result = try await fetchSectionsUseCase.execute(page: next)
            sections.append(contentsOf: result.sections)
            nextPage = result.nextPage
        } catch {
            // Optionally surface error for load more
        }
    }

    func retry() async {
        await loadData()
    }
}

#if DEBUG
extension HomeViewModel {
    static func preview(
        sections: [Section],
        viewState: ViewState = .loaded,
        repository: HomeRepositoryProtocol
    ) -> HomeViewModel {
        let useCase = FetchHomeSectionsUseCase(repository: repository)
        let vm = HomeViewModel(fetchSectionsUseCase: useCase)
        vm.sections = sections
        vm.viewState = viewState
        return vm
    }
}
#endif
