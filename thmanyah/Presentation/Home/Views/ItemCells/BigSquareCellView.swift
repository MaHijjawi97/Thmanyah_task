//
//  BigSquareCellView.swift
//  thmanyah
//
//  Created by MohammadHijjawi on 08/03/2026.
//


import SwiftUI

struct BigSquareCellView: View {
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
                .frame(width: 180, height: 180)
                .clipped()
                .cornerRadius(12)

                if item.hasPlayableMedia {
                    PlayButtonOverlay(playbackService: playbackService, item: item)
                }
            }

            Text(item.title)
                .font(AppTypography.sectionTitle)
                .foregroundStyle(AppTheme.textPrimary)
                .lineLimit(2)
                .multilineTextAlignment(.leading)

            if let sub = item.subtitle ?? item.authorName {
                Text(sub)
                    .font(AppTypography.body)
                    .foregroundStyle(AppTheme.textSecondary)
                    .lineLimit(1)
            }
        }
        .frame(width: 180, alignment: .leading)
    }
}

#Preview {
    let item = SectionItem.audiobook(
        id: "a1",
        name: "كتاب صوتي تجريبي",
        authorName: "كاتب مجهول",
        avatarURL: nil,
        duration: 3600
    )
    return BigSquareCellView(item: item, playbackService: nil)
        .preferredColorScheme(.dark)
        .appBackground()
}
