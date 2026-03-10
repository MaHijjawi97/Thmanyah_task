//
//  AppContainer.swift
//  thmanyah
//
//  Created by MohammadHijjawi on 09/03/2026.
//

import Foundation

/// Container holding app-wide dependencies. Use a single shared instance or pass through environment.
final class AppContainer {
    let apiClient: APIClientProtocol
    let homeRepository: HomeRepositoryProtocol
    let searchRepository: SearchRepositoryProtocol
    let imageLoader: ImageLoader

    init(
        apiClient: APIClientProtocol = APIClient(),
        homeRepository: HomeRepositoryProtocol? = nil,
        searchRepository: SearchRepositoryProtocol? = nil,
        imageLoader: ImageLoader = ImageLoader()
    ) {
        self.apiClient = apiClient
        self.homeRepository = homeRepository ?? DefaultHomeRepository(apiClient: apiClient)
        self.searchRepository = searchRepository ?? DefaultSearchRepository(apiClient: apiClient)
        self.imageLoader = imageLoader
    }

    static let shared = AppContainer()
}
