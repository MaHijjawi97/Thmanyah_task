//
//  QueueCellView.swift
//  thmanyah
//
//  Created by MohammadHijjawi on 08/03/2026.
//

import SwiftUI

struct QueueCellView: View {
    let item: SectionItem
    var playbackService: PlaybackService?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .bottomTrailing) {
                AsyncImage(url: item.imageURL) { phase in
                    switch phase {
                    case .empty:
                        RoundedRectangle(cornerRadius: 10)
                            .fill(AppTheme.backgroundSecondary)
                            .overlay { ProgressView().tint(AppTheme.accent) }
                    case .success(let image):
                        image.resizable().aspectRatio(contentMode: .fill)
                    case .failure:
                        RoundedRectangle(cornerRadius: 10)
                            .fill(AppTheme.backgroundSecondary)
                            .overlay { Image(systemName: "photo").foregroundStyle(AppTheme.textTertiary) }
                    @unknown default:
                        EmptyView()
                }
                }
                .frame(width: 160, height: 160)
                .clipped()
                .cornerRadius(10)

                if item.hasPlayableMedia {
                    PlayButtonOverlay(playbackService: playbackService, item: item)
                }
            }

            Text(item.title)
                .font(AppTypography.title)
                .foregroundStyle(AppTheme.textPrimary)
                .lineLimit(2)
                .multilineTextAlignment(.leading)

            HStack {
                if let count = item.episodeCount {
                    Text(String(format: NSLocalizedString("queue.episodes", comment: ""), count))
                        .font(AppTypography.caption2)
                        .foregroundStyle(AppTheme.textSecondary)
                }
                if let dur = item.durationSeconds {
                    Text(formatDuration(dur))
                        .font(AppTypography.caption2)
                        .foregroundStyle(AppTheme.textSecondary)
                }
            }
        }
        .frame(width: 160, alignment: .leading)
    }

    private func formatDuration(_ seconds: Int) -> String {
        let m = seconds / 60
        let h = m / 60
        if h > 0 { return String(format: NSLocalizedString("duration.hoursMinutes", comment: ""), h, m % 60) }
        return String(format: NSLocalizedString("duration.minutes", comment: ""), m)
    }
}

#Preview {
    let item = SectionItem.podcast(
        id: "q1",
        name: "في قائمة الانتظار",
        description: "حلقة في الطريق",
        avatarURL: nil,
        episodeCount: 8,
        duration: 2700
    )
    return QueueCellView(item: item, playbackService: nil)
        .preferredColorScheme(.dark)
        .appBackground()
}
