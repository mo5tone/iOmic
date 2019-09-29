//
//  BooksViewController.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/8/24.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import DifferenceKit
import Kingfisher
import RxSwift
import UIKit

class BooksViewController: UIViewController, BooksViewProtocol {
    // MARK: - Instance properties

    @IBOutlet private var collectionView: UICollectionView!
    var presenter: BooksViewOutputProtocol!
    private lazy var addBarButtonItem: UIBarButtonItem = .init(barButtonSystemItem: .add, target: nil, action: nil)
    private lazy var segmentedControl: UISegmentedControl = .init(items: ["Favorite", "History"])
    private var books: [ArraySection<Source, Book>] = []

    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    // MARK: - Private instance methods

    private func setup() {
        setupView()
    }

    private func setupView() {
        navigationItem.title = "Books"
        navigationItem.leftBarButtonItem = addBarButtonItem
        navigationItem.titleView = segmentedControl

        collectionView.contentInset = .init(top: 8, left: 8, bottom: 8, right: 8)
        collectionView.registerCell(BookCollectionViewCell.self)
        collectionView.registerSupplementaryView(BookCollectionHeader.self, of: UICollectionView.elementKindSectionHeader)
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        collectionView.delegate = self
    }
}

// MARK: - UICollectionViewDataSource

extension BooksViewController: UICollectionViewDataSource {
    func numberOfSections(in _: UICollectionView) -> Int {
        return books.count
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return books[section].elements.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCollectionViewCell.reusableIdentifier, for: indexPath)
        if let cell = cell as? BookCollectionViewCell {
            cell.setup(book: books[indexPath.section].elements[indexPath.item])
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: BookCollectionHeader.reusableIdentifier, for: indexPath)
        if let reusableView = reusableView as? BookCollectionHeader {
            reusableView.setup(source: books[indexPath.section].model)
        }
        return reusableView
    }
}

// MARK: - UICollectionViewDataSourcePrefetching

extension BooksViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let items = indexPaths.map { (books[$0.section].model, books[$0.section].elements[$0.item]) }
        Source.values.map { source in (source, items.compactMap { $0.0 == source ? $0.1 : nil }) }.forEach {
            ImagePrefetcher(resources: $0.1.compactMap { URL(string: $0.thumbnailUrl ?? "") }, options: [.requestModifier($0.0.imageDownloadRequestModifier)]).start()
        }
    }

    func collectionView(_: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        let items = indexPaths.map { (books[$0.section].model, books[$0.section].elements[$0.item]) }
        Source.values.map { source in (source, items.compactMap { $0.0 == source ? $0.1 : nil }) }.forEach {
            ImagePrefetcher(resources: $0.1.compactMap { URL(string: $0.thumbnailUrl ?? "") }, options: [.requestModifier($0.0.imageDownloadRequestModifier)]).stop()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension BooksViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt _: IndexPath) {
        cell.contentView.layer.cornerRadius = 8.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.flat.clear.cgColor
        cell.contentView.layer.masksToBounds = true

        cell.layer.shadowColor = UIColor.flat.shadow.cgColor
        cell.layer.shadowOffset = .init(width: 0, height: 2.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
    }

    func collectionView(_: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt _: IndexPath) {
        guard let cell = cell as? BookCollectionViewCell else { return }
        cell.cancelDownloadTask()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfCellsPerRow: CGFloat = 3
        let minimumInteritemSpacing = self.collectionView(collectionView, layout: collectionViewLayout, minimumInteritemSpacingForSectionAt: indexPath.section)
        let aspect: CGFloat = 26 / 15
        let width = (collectionView.frame.size.width - collectionView.contentInset.left - collectionView.contentInset.right - (numberOfCellsPerRow - 1) * minimumInteritemSpacing) / numberOfCellsPerRow
        let height = width * aspect
        return .init(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, referenceSizeForHeaderInSection _: Int) -> CGSize {
        let height = UIFont.preferredFont(forTextStyle: .headline).textSize().height + 16 * 2
        return .init(width: collectionView.frame.width, height: height)
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        return 8
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumInteritemSpacingForSectionAt _: Int) -> CGFloat {
        return 8
    }
}
