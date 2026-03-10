//
//  SearchViewModel.swift
//  thmanyah
//
//  Created by MohammadHijjawi on 08/03/2026.
//  Debounce: 200ms after user stops typing. Cancels previous request when query changes.
//

import Foundation
import Combine

@MainActor
final class SearchViewModel: ObservableObject {
    @Published var searchText = ""
    @Published private(set) var sections: [Section] = []
    @Published private(set) var isSearching = false
    @Published private(set) var errorMessage: String?

    private let searchUseCase: SearchContentUseCase
    private var searchTask: Task<Void, Never>?
    private let debounceInterval: UInt64 = 200_000_000 // 200ms in nanoseconds

    init(searchUseCase: SearchContentUseCase) {
        self.searchUseCase = searchUseCase
    }

    /// Call when search text changes. Debounces and cancels previous request.
    func searchTextChanged(_ text: String) {
        searchTask?.cancel()
        searchText = text
        let query = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else {
            sections = []
            errorMessage = nil
            return
        }

        searchTask = Task { @MainActor in
            do {
                try await Task.sleep(nanoseconds: debounceInterval)
            } catch {
                return // Cancelled
            }
            guard !Task.isCancelled else { return }
            await performSearch(query: query)
        }
    }

    private func performSearch(query: String) async {
        isSearching = true
        errorMessage = nil
        defer { isSearching = false }

        do {
            let result = try await searchUseCase.execute(query: query)
            guard !Task.isCancelled else { return }
            sections = result
        } catch {
            guard !Task.isCancelled else { return }
            errorMessage = error.localizedDescription
            sections = []
        }
    }
}
