//
//  MiniPlayerView.swift
//  thmanyah
//
//  Created by MohammadHijjawi on 08/03/2026.
//

import SwiftUI

struct MiniPlayerView: View {
    @ObservedObject var playback: PlaybackService
    @Binding var showFullPlayer: Bool

    var body: some View {
        if playback.hasContent, let item = playback.currentItem {
            Button {
                showFullPlayer = true
            } label: {
                HStack(spacing: 12) {
                    AsyncImage(url: item.imageURL) { phase in
                        switch phase {
                        case .success(let img): img.resizable().aspectRatio(contentMode: .fill)
                        default: Rectangle().fill(AppTheme.textTertiary)
                        }
                    }
                    .frame(width: 48, height: 48)
                    .clipped()
                    .cornerRadius(6)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(item.title)
                            .font(AppTypography.caption)
                            .fontWeight(.medium)
                            .lineLimit(1)
                            .foregroundStyle(AppTheme.textPrimary)
                        Text(formatTime(playback.currentTime) + " · " + formatTime(playback.duration))
                            .font(AppTypography.caption2)
                            .foregroundStyle(AppTheme.textSecondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    Button {
                        playback.seek(seconds: -15)
                    } label: {
                        Image(systemName: "gobackward.15")
                            .font(.system(size: 20))
                            .foregroundStyle(AppTheme.textPrimary)
                    }
                    .buttonStyle(.plain)

                    Button {
                        playback.togglePlayPause()
                    } label: {
                        Image(systemName: playback.isPlaying ? "pause.fill" : "play.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(AppTheme.accent)
                    }
                    .buttonStyle(.plain)

                    Button {
                        playback.seek(seconds: 30)
                    } label: {
                        Image(systemName: "goforward.30")
                            .font(.system(size: 20))
                            .foregroundStyle(AppTheme.textPrimary)
                    }
                    .buttonStyle(.plain)

                    Menu {
                        Button("Mark as played") { }
                        Button("Play next in queue") { }
                        Button("Play last in queue") { }
                        Button("Add to Favorites") { }
                        Button("Download Episode") { }
                        Button("Share") { }
                        Button("Bookmark") { }
                    } label: {
                        Image(systemName: "ellipsis")
                            .rotationEffect(.degrees(90))
                            .font(.system(size: 18))
                            .foregroundStyle(AppTheme.textSecondary)
                            .padding(.leading, 4)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(AppTheme.surfaceElevated)
            }
            .buttonStyle(.plain)
            .cornerRadius(15)
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
        id: "demo-mini",
        name: "حلقة مصغّرة",
        podcastName: "برنامج ثمانية",
        avatarURL: nil,
        duration: 1800
    )
    let playback = PlaybackService.preview(with: demoItem, currentTime: 120)
    return MiniPlayerView(playback: playback, showFullPlayer: .constant(false))
        .preferredColorScheme(.dark)
        .appBackground()
}
