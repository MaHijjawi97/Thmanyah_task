//
//  SearchSquareCell.swift
//  thmanyah
//
//  Created by MohammadHijjawi on 08/03/2026.
//

import UIKit
import SwiftUI

final class SearchSquareCell: UICollectionViewCell {
    static let reuseId = "SearchSquareCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with item: SectionItem, playbackService: PlaybackService?) {
        if #available(iOS 16.0, *) {
            contentConfiguration = UIHostingConfiguration {
                SquareCellView(item: item, playbackService: playbackService)
            }
        } else {
            // Fallback: no-op, or keep a very simple UIKit layout if needed
        }
    }
}
