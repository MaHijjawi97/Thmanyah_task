//
//  SearchViewWrapper.swift
//  thmanyah
//
//  Created by MohammadHijjawi on 08/03/2026.
//  Bridges the UIKit SearchViewController into SwiftUI.
//

import SwiftUI

struct SearchViewWrapper: UIViewControllerRepresentable {
    @Environment(\.playbackService) private var playbackService

    func makeUIViewController(context: Context) -> UINavigationController {
        let container = AppContainer.shared
        let useCase = SearchContentUseCase(repository: container.searchRepository)
        let viewModel = SearchViewModel(searchUseCase: useCase)
        let searchVC = SearchViewController(viewModel: viewModel, playbackService: playbackService)
        let nav = UINavigationController(rootViewController: searchVC)
        nav.navigationBar.prefersLargeTitles = true
        return nav
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        // No-op for now; search view model handles its own state.
    }
}

#Preview {
    SearchViewWrapper()
        .preferredColorScheme(.dark)
}

