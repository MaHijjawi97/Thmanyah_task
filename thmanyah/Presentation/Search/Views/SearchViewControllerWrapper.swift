//
//  SearchViewControllerWrapper.swift
//  thmanyah
//
//  Created by MohammadHijjawi on 08/03/2026.
//  Wraps UIKit SearchViewController for use inside SwiftUI NavigationStack.
//

import SwiftUI
import UIKit

struct SearchViewControllerWrapper: UIViewControllerRepresentable {
    @Environment(\.playbackService) private var playbackService

    func makeUIViewController(context: Context) -> UINavigationController {
        let container = AppContainer.shared
        let useCase = SearchContentUseCase(repository: container.searchRepository)
        let viewModel = SearchViewModel(searchUseCase: useCase)
        let searchVC = SearchViewController(viewModel: viewModel, playbackService: playbackService)
        let nav = UINavigationController(rootViewController: searchVC)
        nav.navigationBar.prefersLargeTitles = true
        nav.navigationBar.tintColor = UIColor.appAccent
        nav.navigationBar.barTintColor = UIColor.appBackground

        let titleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.appTextPrimary
        ]
        nav.navigationBar.titleTextAttributes = titleAttributes
        nav.navigationBar.largeTitleTextAttributes = titleAttributes
        return nav
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
}
