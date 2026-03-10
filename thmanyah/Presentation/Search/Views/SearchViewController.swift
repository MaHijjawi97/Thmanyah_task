//
//  SearchViewController.swift
//  thmanyah
//
//  Created by MohammadHijjawi on 08/03/2026.
//  UIKit search screen: UISearchBar, debounced search, results in same section layouts as Home.
//

import UIKit
import Combine

final class SearchViewController: UIViewController {
    private let viewModel: SearchViewModel
    private let playbackService: PlaybackService?
    private var cancellables = Set<AnyCancellable>()

    private lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = NSLocalizedString("search.placeholder", comment: "")
        bar.delegate = self
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            self?.sectionLayout(for: sectionIndex) ?? Self.fallbackLayout()
        }
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .appBackground
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(SearchSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SearchSectionHeader.reuseId)
        cv.register(SearchSquareCell.self, forCellWithReuseIdentifier: SearchSquareCell.reuseId)
        cv.register(SearchGridLineCell.self, forCellWithReuseIdentifier: SearchGridLineCell.reuseId)
        cv.register(SearchBigSquareCell.self, forCellWithReuseIdentifier: SearchBigSquareCell.reuseId)
        cv.register(SearchQueueCell.self, forCellWithReuseIdentifier: SearchQueueCell.reuseId)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()

    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let v = UIActivityIndicatorView(style: .medium)
        v.hidesWhenStopped = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private lazy var emptyLabel: UILabel = {
        let l = UILabel()
        l.text = NSLocalizedString("search.typeToSearch", comment: "")
        l.textColor = .appTextSecondary
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private var sections: [Section] = []

    init(viewModel: SearchViewModel, playbackService: PlaybackService?) {
        self.viewModel = viewModel
        self.playbackService = playbackService
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appBackground
        // Slightly push content down so the large title "Search"
        // has more breathing room from the top safe area.
        additionalSafeAreaInsets.top = 4
        title = NSLocalizedString("search.title", comment: "")
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.hidesSearchBarWhenScrolling = false
        searchBar.barTintColor = .appBackground
        searchBar.searchTextField.backgroundColor = UIColor.appBackgroundSecondary
        searchBar.searchTextField.textColor = .appTextPrimary
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        view.addSubview(loadingIndicator)
        view.addSubview(emptyLabel)

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 56),

            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])

        bindViewModel()
        configureKeyboardDismissal()
    }

    private func bindViewModel() {
        viewModel.$sections
            .receive(on: DispatchQueue.main)
            .sink { [weak self] sections in
                self?.sections = sections
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)

        viewModel.$isSearching
            .receive(on: DispatchQueue.main)
            .sink { [weak self] searching in
                if searching {
                    self?.loadingIndicator.startAnimating()
                } else {
                    self?.loadingIndicator.stopAnimating()
                }
            }
            .store(in: &cancellables)

        Publishers.CombineLatest3(viewModel.$searchText, viewModel.$sections, viewModel.$isSearching)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text, sections, isSearching in
                guard let self else { return }
                if text.trimmingCharacters(in: .whitespaces).isEmpty {
                    self.emptyLabel.text = NSLocalizedString("search.typeToSearch", comment: "")
                    self.emptyLabel.isHidden = false
                } else if !isSearching && sections.isEmpty {
                    self.emptyLabel.text = NSLocalizedString("search.noResults", comment: "")
                    self.emptyLabel.isHidden = false
                } else {
                    self.emptyLabel.isHidden = true
                }
            }
            .store(in: &cancellables)
    }

    /// Adds a toolbar with a Done button above the keyboard and allows tapping outside to dismiss.
    private func configureKeyboardDismissal() {
        // Toolbar with Done button for the search text field
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDoneOnKeyboard))
        toolbar.items = [flexible, done]
        searchBar.searchTextField.inputAccessoryView = toolbar

        // Tap anywhere in the view to dismiss the keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc private func didTapDoneOnKeyboard() {
        searchBar.resignFirstResponder()
    }

    private func sectionLayout(for sectionIndex: Int) -> NSCollectionLayoutSection? {
        guard sectionIndex < sections.count else { return Self.fallbackLayout() }
        let section = sections[sectionIndex]
        switch section.layoutType {
        case .square, .queue:
            return horizontalScrollSection(itemWidth: 140, itemHeight: 200)
        case .bigSquare:
            return horizontalScrollSection(itemWidth: 180, itemHeight: 260)
        case .twoLinesGrid:
            return gridSection()
        }
    }

    private func horizontalScrollSection(itemWidth: CGFloat, itemHeight: CGFloat) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(itemWidth), heightDimension: .absolute(itemHeight))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(itemWidth), heightDimension: .absolute(itemHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 16
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44))
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        ]
        return section
    }

    private func gridSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .estimated(220)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(220)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44))
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        ]
        return section
    }

    private static func fallbackLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(80)
            )
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(80)
            ),
            subitems: [item]
        )
        return NSCollectionLayoutSection(group: group)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchTextChanged(searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sections[section].items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = sections[indexPath.section]
        let item = section.items[indexPath.item]
        switch section.layoutType {
        case .square, .queue:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchSquareCell.reuseId, for: indexPath) as! SearchSquareCell
            cell.configure(with: item, playbackService: playbackService)
            return cell
        case .bigSquare:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchBigSquareCell.reuseId, for: indexPath) as! SearchBigSquareCell
            cell.configure(with: item)
            return cell
        case .twoLinesGrid:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchGridLineCell.reuseId, for: indexPath) as! SearchGridLineCell
            cell.configure(with: item, playbackService: playbackService)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SearchSectionHeader.reuseId, for: indexPath) as! SearchSectionHeader
        header.configure(title: sections[indexPath.section].name)
        return header
    }
}
