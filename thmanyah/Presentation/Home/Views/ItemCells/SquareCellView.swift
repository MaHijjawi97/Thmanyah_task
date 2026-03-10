//
//  SquareCellView.swift
//  thmanyah
//
//  Created by MohammadHijjawi on 08/03/2026.
//


import SwiftUI

struct SquareCellView: View {
    let item: SectionItem
    var playbackService: PlaybackService?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .bottomTrailing) {
                AsyncImage(url: item.imageURL) { phase in
                    switch phase {
                    case .empty:
                        Rectangle()
                            .fill(AppTheme.backgroundSecondary)
                            .overlay { ProgressView().tint(AppTheme.accent) }
                    case .success(let image):
                        image.resizable().aspectRatio(contentMode: .fill)
                    case .failure:
                        Rectangle()
                            .fill(AppTheme.backgroundSecondary)
                            .overlay { Image(systemName: "photo").foregroundStyle(AppTheme.textTertiary) }
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(width: 140, height: 140)
                .clipped()
                .cornerRadius(8)

                if item.hasPlayableMedia {
                    PlayButtonOverlay(playbackService: playbackService, item: item)
                }
            }

            Text(item.title)
                .font(AppTypography.title)
                .foregroundStyle(AppTheme.textPrimary)
                .lineLimit(2)
                .multilineTextAlignment(.leading)

            if let sub = item.subtitle ?? item.authorName {
                Text(sub)
                    .font(AppTypography.caption)
                    .foregroundStyle(AppTheme.textSecondary)
                    .lineLimit(1)
            }
            if let dur = item.durationSeconds {
                Text(formatDuration(dur))
                    .font(AppTypography.caption2)
                    .foregroundStyle(AppTheme.textSecondary)
            }
        }
        .frame(width: 140, alignment: .leading)
    }

    private func formatDuration(_ seconds: Int) -> String {
        let m = seconds / 60
        let h = m / 60
        if h > 0 { return String(format: NSLocalizedString("duration.hoursMinutes", comment: ""), h, m % 60) }
        return String(format: NSLocalizedString("duration.minutes", comment: ""), m)
    }
}

struct PlayButtonOverlay: View {
    var playbackService: PlaybackService?
    let item: SectionItem

    var body: some View {
        Button {
            playbackService?.play(item)
        } label: {
            Image(systemName: "play.fill")
                .font(.system(size: 20))
                .foregroundStyle(AppTheme.accent)
                .frame(width: 40, height: 40)
                .background(AppTheme.surfaceElevated.opacity(0.9))
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
        .padding(8)
    }
}

#Preview {
    let item = SectionItem.podcast(
        id: "p1",
        name: "برنامج ثمانية",
        description: "حلقة عن القصص الصوتية",
        avatarURL: nil,
        episodeCount: 24,
        duration: 1800
    )
    return SquareCellView(item: item, playbackService: nil)
        .preferredColorScheme(.dark)
        .appBackground()
}
