//
//  SearchView.swift
//  thmanyah
//
//  Created by MohammadHijjawi on 09/03/2026.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel: SearchViewModel
    var playbackService: PlaybackService?

    init(playbackService: PlaybackService? = nil) {
        self.playbackService = playbackService
        let container = AppContainer.shared
        let useCase = SearchContentUseCase(repository: container.searchRepository)
        _viewModel = StateObject(wrappedValue: SearchViewModel(searchUseCase: useCase))
    }

    var body: some View {
        VStack(spacing: 0) {
            searchField

            ZStack {
                resultsContent

                if viewModel.isSearching {
                    ProgressView()
                        .tint(AppTheme.accent)
                }
            }
        }
        .background(AppTheme.background.ignoresSafeArea())
        .onTapGesture {
            // Dismiss keyboard when tapping outside
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .navigationTitle(NSLocalizedString("search.title", comment: ""))
        .navigationBarTitleDisplayMode(.large)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(AppTheme.background, for: .navigationBar)
    }

    private var searchField: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(AppTheme.textSecondary)
            TextField(NSLocalizedString("search.placeholder", comment: ""), text: $viewModel.searchText)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .submitLabel(.done) // Adds "Done" to keyboard
            
            if !viewModel.searchText.isEmpty {
                Button {
                    viewModel.searchText = ""
                    viewModel.searchTextChanged("")
                    // Dismiss keyboard
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(AppTheme.textSecondary)
                }
            }
        }
        .padding(10)
        .background(AppTheme.backgroundSecondary)
        .cornerRadius(12)
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .onChange(of: viewModel.searchText) { newValue in
            viewModel.searchTextChanged(newValue)
        }
    }

    private var resultsContent: some View {
        Group {
            if viewModel.searchText.trimmingCharacters(in: .whitespaces).isEmpty {
                Text(NSLocalizedString("search.typeToSearch", comment: ""))
                    .font(AppTypography.body)
                    .foregroundStyle(AppTheme.textSecondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if !viewModel.isSearching && viewModel.sections.isEmpty {
                Text(NSLocalizedString("search.noResults", comment: ""))
                    .font(AppTypography.body)
                    .foregroundStyle(AppTheme.textSecondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 24) {
                        ForEach(Array(viewModel.sections.enumerated()), id: \.element.name) { _, section in
                            SectionView(section: section, playbackService: playbackService)
                        }
                    }
                    .padding(.vertical, 16)
                }
            }
        }
    }
}

#Preview {
    SearchView()
        .preferredColorScheme(.dark)
}
