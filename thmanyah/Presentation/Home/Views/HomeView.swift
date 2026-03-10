//
//  HomeView.swift
//  thmanyah
//
//  Created by MohammadHijjawi on 08/03/2026.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel
    @Environment(\.playbackService) private var playbackService
    @State private var showSearch = false

    init(viewModel: HomeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.viewState {
                case .idle, .loading:
                    ProgressView(NSLocalizedString("home.loading", comment: ""))
                        .foregroundStyle(AppTheme.textSecondary)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                case .loaded:
                    mainContent
                case .error(let message):
                    errorView(message: message)
                }
            }
            .navigationTitle(NSLocalizedString("home.title", comment: ""))
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(AppTheme.background, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showSearch = true
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(AppTheme.textPrimary)
                    }
                }
            }
            .navigationDestination(isPresented: $showSearch) {
                SearchView(playbackService: playbackService)
            }
            .task {
                if case .idle = viewModel.viewState {
                    await viewModel.loadData()
                }
            }
            .refreshable {
                await viewModel.loadData()
            }
        }
    }

    private var mainContent: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 24) {
                ForEach(Array(viewModel.sections.enumerated()), id: \.element.name) { index, section in
                    SectionView(section: section, playbackService: playbackService)
                        .onAppear {
                            if index == viewModel.sections.count - 2 {
                                Task { await viewModel.loadMoreIfNeeded() }
                            }
                        }
                }
            }
            .padding(.bottom, 24)
        }
        .scrollContentBackground(.hidden)
    }

    private func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundStyle(AppTheme.textSecondary)
            Text(message)
                .multilineTextAlignment(.center)
                .font(AppTypography.body)
                .foregroundStyle(AppTheme.textSecondary)
            Button(NSLocalizedString("home.retry", comment: "")) {
                Task { await viewModel.retry() }
            }
            .tint(AppTheme.accent)
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

#Preview {
    let items = [
        SectionItem.podcast(
            id: "p1",
            name: "برنامج ثمانية",
            description: "بودكاست من ثمانية",
            avatarURL: nil,
            episodeCount: 10,
            duration: 1800
        ),
        SectionItem.podcast(
            id: "p2",
            name: "السعودية اليوم",
            description: "أخبار وتحليلات",
            avatarURL: nil,
            episodeCount: 4,
            duration: 2100
        )
    ]
    let section = Section(
        name: "الأكثر استماعًا",
        layoutType: .square,
        contentType: .podcast,
        order: 0,
        items: items
    )
    let vm = HomeViewModel.preview(
        sections: [section],
        repository: PreviewHomeRepository()
    )
    let playback = PlaybackService()
    HomeView(viewModel: vm)
        .environment(\.playbackService, playback)
        .preferredColorScheme(.dark)
        .appBackground()
}

private struct PreviewHomeRepository: HomeRepositoryProtocol {
    func fetchSections(page: Int) async throws -> (sections: [Section], nextPage: Int?) {
        return ([], nil)
    }
}
