//
//  PagesViewController.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/10/9.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Kingfisher
import UIKit

class PagesViewController: UIViewController, PagesViewProtocol {
    // MARK: - Instance properties

    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var slider: UISlider!
    @IBOutlet private var indexLabel: UILabel!
    var presenter: PagesViewOutputProtocol!
    private var collectionViewFlowLayout: UICollectionViewFlowLayout = .init()
    private var pages: [Page] = []

    // MARK: - Public instance methods

    func reload(chapter _: Chapter, pages: [Page]) {
        collectionView.reload(using: .init(source: self.pages, target: pages), setData: { self.pages = $0 })
    }

    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter.viewDidLoad()
    }

    // MARK: - Private instance methods

    private func setup() {
        setupView()
        setupBinding()
    }

    private func setupView() {
        view.backgroundColor = UIColor.flat.none

        collectionViewFlowLayout.scrollDirection = .horizontal

        collectionView.collectionViewLayout = collectionViewFlowLayout
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.registerCell(PageCollectionViewCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self

        slider.minimumValue = 0
        slider.maximumValue = 0
        slider.value = 0

        indexLabel.textColor = UIColor.flat.lightText
        indexLabel.font = .preferredFont(forTextStyle: .body)
    }

    private func setupBinding() {}
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PagesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        return collectionView.frame.size
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumInteritemSpacingForSectionAt _: Int) -> CGFloat {
        return 0
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        return 0
    }
}

// MARK: - UICollectionViewDataSource

extension PagesViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return pages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PageCollectionViewCell.reusableIdentifier, for: indexPath)
        if let cell = cell as? PageCollectionViewCell {
            cell.delegate = self
            cell.setup(pages[indexPath.item])
        }
        return cell
    }
}

// MARK: - UICollectionViewDataSourcePrefetching

extension PagesViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let pages = indexPaths.compactMap { [weak self] in self?.pages[$0.item] }
        Source.values.map { source in (source, pages.filter { $0.source == source }) }.forEach {
            let options: KingfisherOptionsInfo = [.requestModifier($0.0.imageDownloadRequestModifier)]
            ImagePrefetcher(resources: $0.1.compactMap { URL(string: $0.imageUrl ?? "") }, options: options).start()
        }
    }
}

// MARK: - PageCollectionViewCellDelegate

extension PagesViewController: PageCollectionViewCellDelegate {
    func pageCollectionViewCellOnTap(_: PageCollectionViewCell) {
        let isHidden = slider.isHidden
        navigationController?.setNavigationBarHidden(!isHidden, animated: true)
        UIView.animate(withDuration: 0.2, animations: { [weak self] in self?.slider.isHidden = !isHidden })
    }
}
