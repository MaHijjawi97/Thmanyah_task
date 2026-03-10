//
//  SearchSectionHeader.swift
//  thmanyah
//
//  Created by MohammadHijjawi on 08/03/2026.
//


import UIKit

final class SearchSectionHeader: UICollectionReusableView {
    static let reuseId = "SearchSectionHeader"

    private let label: UILabel = {
        let l = UILabel()
        l.font = .preferredFont(forTextStyle: .headline)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(title: String) {
        label.text = title
        label.textColor = UIColor.appTextPrimary
        label.font = .appSectionTitle
    }
}
