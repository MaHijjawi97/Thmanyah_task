//
//  SearchQueueCell.swift
//  thmanyah
//
//  Created by MohammadHijjawi on 08/03/2026.
//


import UIKit

final class SearchQueueCell: UICollectionViewCell {
    static let reuseId = "SearchQueueCell"

    private let imageView: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFill
        v.clipsToBounds = true
        v.backgroundColor = UIColor.appBackgroundSecondary
        v.layer.cornerRadius = 10
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 14, weight: .medium)
        l.numberOfLines = 2
        l.textColor = .appTextPrimary
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 160),
            imageView.heightAnchor.constraint(equalToConstant: 160),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with item: SectionItem) {
        titleLabel.text = item.title
        imageView.image = nil
        guard let url = item.imageURL else { return }
        Task {
            let data = try? await URLSession.shared.data(from: url).0
            let img = data.flatMap { UIImage(data: $0) }
            await MainActor.run { [weak self] in
                self?.imageView.image = img
            }
        }
    }
}
