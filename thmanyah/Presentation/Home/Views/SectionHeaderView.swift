//
//  SectionHeaderView.swift
//  thmanyah
//
//  Created by MohammadHijjawi on 09/03/2026.
//

import SwiftUI

struct SectionHeaderView: View {
    let title: String
    var actionTitle: String?
    var action: (() -> Void)?

    var body: some View {
        HStack(alignment: .center) {
            Text(title)
                .font(AppTypography.sectionTitle)
                .foregroundStyle(AppTheme.accent)

            Spacer()

            if let actionTitle, let action {
                Button(actionTitle) {
                    action()
                }
                .font(AppTypography.caption)
                .foregroundStyle(AppTheme.textSecondary)
            }
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    VStack(spacing: 16) {
        SectionHeaderView(title: "الأكثر استماعًا")
        SectionHeaderView(
            title: "توصيات الفريق",
            actionTitle: NSLocalizedString("section.seeAll", comment: ""),
            action: {}
        )
    }
    .preferredColorScheme(.dark)
    .appBackground()
}

