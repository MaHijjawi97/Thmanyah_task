//
//  GridLineCellView.swift
//  thmanyah
//
//  Created by MohammadHijjawi on 08/03/2026.
//

import SwiftUI

struct GridLineCellView: View {
    let item: SectionItem
    var playbackService: PlaybackService?
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            AsyncImage(url: item.imageURL) { phase in
                switch phase {
                case .empty:
                    RoundedRectangle(cornerRadius: 6)
                        .fill(AppTheme.backgroundSecondary)
                        .overlay { ProgressView().tint(AppTheme.accent) }
                case .success(let image):
                    image.resizable().aspectRatio(contentMode: .fill)
                case .failure:
                    RoundedRectangle(cornerRadius: 6)
                        .fill(AppTheme.backgroundSecondary)
                        .overlay { Image(systemName: "photo").foregroundStyle(AppTheme.textTertiary) }
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 80, height:80)
            .clipped()
            .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 6) {
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
                HStack{
                    if let dur = item.durationSeconds {
                        Button {
                            playbackService?.play(item)
                        } label: {
                            HStack{
                                Image(systemName: "play.fill")
                                    .font(.system(size: 10))
                                
                                Text(formatDuration(dur))
                                    .font(AppTypography.caption2)
                                    .foregroundStyle(AppTheme.textSecondary)
                            }
                            .foregroundStyle(AppTheme.textSecondary)
                            
                        }
                        .padding(.vertical,5)
                        .padding(.horizontal,8)
                        .background(AppTheme.backgroundSecondary)
                        .clipShape(.capsule)
                        .buttonStyle(.plain)
                    }
                    Spacer()
                    if item.hasPlayableMedia {
                        HStack(spacing: 12) {
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
                                    .padding(.vertical, 8)
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(.horizontal,12)
                    }
                }
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 10)
        .contentShape(Rectangle())
        .onTapGesture {
            if item.hasPlayableMedia {
                playbackService?.play(item)
            }
        }
    }
    
    private func formatDuration(_ seconds: Int) -> String {
        let m = seconds / 60
        let h = m / 60
        if h > 0 { return String(format: NSLocalizedString("duration.hoursMinutes", comment: ""), h, m % 60) }
        return String(format: NSLocalizedString("duration.minutes", comment: ""), m)
    }
}

#Preview {
    let item = SectionItem.episode(
        id: "e1",
        name: "حلقة قصيرة",
        podcastName: "برنامج تجريبي",
        avatarURL: nil,
        duration: 900
    )
    return GridLineCellView(item: item, playbackService: nil)
        .preferredColorScheme(.dark)
        .appBackground()
}
