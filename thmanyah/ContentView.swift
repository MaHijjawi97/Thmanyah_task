//
//  ContentView.swift
//  thmanyah
//
//  Created by MohammadHijjawi on 08/03/2026.
//

import SwiftUI

struct ContentView: View {
    private let container = AppContainer.shared
    @StateObject private var playback = PlaybackService()
    @State private var showFullPlayer = false

    var body: some View {
        let useCase = FetchHomeSectionsUseCase(repository: container.homeRepository)
        ZStack(alignment: .bottom) {
            HomeView(viewModel: HomeViewModel(fetchSectionsUseCase: useCase))

            if playback.hasContent {
                MiniPlayerView(playback: playback, showFullPlayer: $showFullPlayer)
                    .padding(.bottom, 10)
            }
        }
        .environment(\.playbackService, playback)
        .fullScreenCover(isPresented: $showFullPlayer) {
            FullPlayerView(playback: playback, isPresented: $showFullPlayer)
        }
        .preferredColorScheme(.dark)
        .appBackground()
    }
}

#Preview {
    ContentView()
}
