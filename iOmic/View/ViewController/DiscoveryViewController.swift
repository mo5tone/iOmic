//
//  DiscoveryViewController.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/9/29.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import DifferenceKit
import Kingfisher
import UIKit

class DiscoveryViewController: UIViewController, DiscoveryViewProtocol {
    // MARK: - Instance properties

    @IBOutlet private var collectionView: UICollectionView!
    var presenter: DiscoveryViewOutputProtocol!
    private lazy var sourceBarButtonItem: UIBarButtonItem = .init(image: #imageLiteral(resourceName: "ic_navigationbar_tune"), style: .plain, target: nil, action: nil)
    private var books: ArraySection<Source, Book> = .init(model: Source.values[0], elements: [])

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
        navigationItem.leftBarButtonItem = sourceBarButtonItem

        collectionView.contentInset = .init(top: 8, left: 8, bottom: 8, right: 8)
        collectionView.registerCell(BookCollectionViewCell.self)
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        collectionView.delegate = self
    }
}

// MARK: - UICollectionViewDataSource

extension DiscoveryViewController: UICollectionViewDataSource {
    func numberOfSections(in _: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return books.elements.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCollectionViewCell.reusableIdentifier, for: indexPath)
        if let cell = cell as? BookCollectionViewCell {
            cell.setup(book: books.elements[indexPath.item])
        }
        return cell
    }
}

// MARK: - UICollectionViewDataSourcePrefetching

extension DiscoveryViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let resources = indexPaths.map { books.elements[$0.item] }.compactMap { URL(string: $0.thumbnailUrl ?? "") }
        ImagePrefetcher(resources: resources, options: [.requestModifier(books.model.imageDownloadRequestModifier)]).start()
    }

    func collectionView(_: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        let resources = indexPaths.map { books.elements[$0.item] }.compactMap { URL(string: $0.thumbnailUrl ?? "") }
        ImagePrefetcher(resources: resources, options: [.requestModifier(books.model.imageDownloadRequestModifier)]).stop()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension DiscoveryViewController: UICollectionViewDelegateFlowLayout {
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

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        return 8
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumInteritemSpacingForSectionAt _: Int) -> CGFloat {
        return 8
    }
}
