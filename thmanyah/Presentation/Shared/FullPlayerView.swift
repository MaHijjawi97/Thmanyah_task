//
//  FullPlayerView.swift
//  thmanyah
//
//  Created by MohammadHijjawi on 08/03/2026.
//

import SwiftUI

struct FullPlayerView: View {
    @ObservedObject var playback: PlaybackService
    @Binding var isPresented: Bool

    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()

            if let item = playback.currentItem {
                VStack(spacing: 24) {
                    HStack {
                        Button { isPresented = false } label: {
                            Image(systemName: "chevron.down")
                                .font(.title2)
                                .foregroundStyle(AppTheme.textPrimary)
                        }
                        Spacer()
                        if playback.canSwitchToVideo || playback.canSwitchToAudio {
                            HStack(spacing: 8) {
                                if playback.canSwitchToAudio {
                                    Button(NSLocalizedString("player.audio", comment: "")) {
                                        playback.switchToAudio()
                                    }
                                    .font(AppTypography.caption2)
                                    .foregroundStyle(playback.mode == .audio ? AppTheme.accent : AppTheme.textSecondary)
                                }
                                if playback.canSwitchToVideo {
                                    Button(NSLocalizedString("player.video", comment: "")) {
                                        playback.switchToVideo()
                                    }
                                    .font(AppTypography.caption2)
                                    .foregroundStyle(playback.mode == .video ? AppTheme.accent : AppTheme.textSecondary)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)

                    AsyncImage(url: item.imageURL) { phase in
                        switch phase {
                        case .success(let img): img.resizable().aspectRatio(contentMode: .fill)
                        default: RoundedRectangle(cornerRadius: 12).fill(AppTheme.textTertiary)
                        }
                    }
                    .frame(width: 280, height: 280)
                    .clipped()
                    .cornerRadius(12)

                    VStack(alignment: .leading, spacing: 4) {
                        if let sub = item.subtitle ?? item.authorName {
                            Text(sub)
                                .font(AppTypography.caption)
                                .foregroundStyle(AppTheme.textSecondary)
                        }
                        Text(item.title)
                            .font(AppTypography.title)
                            .foregroundStyle(AppTheme.textPrimary)
                            .lineLimit(2)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                    if playback.duration > 0 {
                        VStack(spacing: 8) {
                            Slider(
                                value: Binding(
                                    get: { playback.duration > 0 ? playback.currentTime / playback.duration : 0 },
                                    set: { playback.seekToProgress($0) }
                                ),
                                in: 0...1
                            )
                            .tint(AppTheme.accent)

                            HStack {
                                Text(formatTime(playback.currentTime))
                                    .font(AppTypography.caption2)
                                    .foregroundStyle(AppTheme.textSecondary)
                                Spacer()
                                Text("-" + formatTime(max(0, playback.duration - playback.currentTime)))
                                    .font(AppTypography.caption2)
                                    .foregroundStyle(AppTheme.textSecondary)
                            }
                        }
                        .padding(.horizontal, 24)
                    }

                    HStack(spacing: 32) {
                        Button { playback.seek(seconds: -15) } label: {
                            Image(systemName: "gobackward.15")
                                .font(.title2)
                                .foregroundStyle(AppTheme.textPrimary)
                        }
                        Button { playback.togglePlayPause() } label: {
                            Image(systemName: playback.isPlaying ? "pause.fill" : "play.fill")
                                .font(.system(size: 44))
                                .foregroundStyle(AppTheme.accent)
                        }
                        Button { playback.seek(seconds: 30) } label: {
                            Image(systemName: "goforward.30")
                                .font(.title2)
                                .foregroundStyle(AppTheme.textPrimary)
                        }
                    }
                    .padding(.top, 8)

                    Spacer()
                }
                .padding(.top, 16)
            }
        }
    }

    private func formatTime(_ seconds: TimeInterval) -> String {
        guard seconds.isFinite, seconds >= 0 else { return "0:00" }
        let m = Int(seconds) / 60
        let s = Int(seconds) % 60
        return String(format: "%d:%02d", m, s)
    }
}

#Preview {
    let demoItem = SectionItem.episode(
        id: "demo",
        name: "حلقة تجريبية",
        podcastName: "برنامج ثمانية",
        avatarURL: nil,
        duration: 1800
    )
    let playback = PlaybackService.preview(with: demoItem, currentTime: 300)
    return FullPlayerView(playback: playback, isPresented: .constant(true))
        .preferredColorScheme(.dark)
        .appBackground()
}
