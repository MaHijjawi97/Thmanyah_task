//
//  SectionView.swift
//  thmanyah
//
//  Created by MohammadHijjawi on 08/03/2026.
//

import SwiftUI

struct SectionView: View {
    let section: Section
    var playbackService: PlaybackService?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeaderView(title: section.name)

            switch section.layoutType {
            case .square:
                squareLayout
            case .bigSquare:
                bigSquareLayout
            case .twoLinesGrid:
                twoLinesGridLayout
            case .queue:
                queueLayout
            }
        }
        .padding(.vertical, 8)
    }

    private var squareLayout: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(alignment: .top, spacing: 16) {
                ForEach(section.items, id: \.id) { item in
                    SquareCellView(item: item, playbackService: playbackService)
                }
            }
            .padding(.horizontal)
        }
        .frame(height: 220)
    }

    private var bigSquareLayout: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(alignment: .top, spacing: 16) {
                ForEach(section.items, id: \.id) { item in
                    BigSquareCellView(item: item, playbackService: playbackService)
                }
            }
            .padding(.horizontal)
        }
        .frame(height: 260)
    }

    private var twoLinesGridLayout: some View {
        // Chunk items into pages of up to 2 rows per page.
        let items = section.items
        let chunks: [[SectionItem]] = stride(from: 0, to: items.count, by: 2).map { index in
            Array(items[index..<min(index + 2, items.count)])
        }
        let screenWidth = UIScreen.main.bounds.width
        let pageWidth = screenWidth * 0.9
        let horizontalPadding = (screenWidth - pageWidth) / 2

        return TabView {
            ForEach(Array(chunks.enumerated()), id: \.offset) { _, pageItems in
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(pageItems, id: \.id) { item in
                        GridLineCellView(item: item, playbackService: playbackService)
                    }
                }
                .frame(width: pageWidth, alignment: .leading)
                .padding(.horizontal, horizontalPadding)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(height: 210)
    }
    
    private var queueLayout: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(alignment: .top, spacing: 16) {
                ForEach(section.items, id: \.id) { item in
                    QueueCellView(item: item, playbackService: playbackService)
                }
            }
            .padding(.horizontal)
        }
        .frame(height: 240)
    }
}


#Preview("Section – Two Lines Grid") {
    let items = [
        SectionItem.episode(
            id: "e1",
            name: "حلقة ١",
            podcastName: "برنامج ثمانية",
            avatarURL: nil,
            duration: 1800
        ),
        SectionItem.episode(
            id: "e2",
            name: "حلقة ٢",
            podcastName: "برنامج ثمانية",
            avatarURL: nil,
            duration: 2100
        ),
        SectionItem.episode(
            id: "e3",
            name: "حلقة 3",
            podcastName: "برنامج ثمانية",
            avatarURL: nil,
            duration: 2100
        ),
        SectionItem.episode(
            id: "e4",
            name: "حلقة 4",
            podcastName: "برنامج ثمانية",
            avatarURL: nil,
            duration: 2100
        ),
        SectionItem.episode(
            id: "e5",
            name: "حلقة5٢",
            podcastName: "برنامج ثمانية",
            avatarURL: nil,
            duration: 2100
        )
    ]
    let section = Section(
        name: "الحلقات الأخيرة",
        layoutType: .twoLinesGrid,
        contentType: .episode,
        order: 1,
        items: items
    )
    return SectionView(section: section, playbackService: nil)
        .preferredColorScheme(.dark)
        .appBackground()
}

#Preview("Section – Square") {
    let items = [
        SectionItem.podcast(
            id: "1",
            name: "برنامج ثمانية",
            description: "حلقة تجريبية",
            avatarURL: nil,
            episodeCount: 12,
            duration: 1800
        ),
        SectionItem.podcast(
            id: "2",
            name: "بودكاست التجربة",
            description: "نبذة قصيرة",
            avatarURL: nil,
            episodeCount: 5,
            duration: 2400
        )
    ]
    let section = Section(
        name: "شائع الآن",
        layoutType: .square,
        contentType: .podcast,
        order: 0,
        items: items
    )
    return SectionView(section: section, playbackService: nil)
        .preferredColorScheme(.dark)
        .appBackground()
}
