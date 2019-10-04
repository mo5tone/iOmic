//
//  ChaptersViewController.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/10/3.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import MarqueeLabel
import RxSwift
import UIKit

class ChaptersViewController: UIViewController, ChaptersViewProtocol {
    private let bag: DisposeBag = .init()
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var infoContainerView: UIView!
    @IBOutlet private var coverImageView: UIImageView!
    @IBOutlet private var summaryTextView: UITextView!
    @IBOutlet private var authorLabel: UILabel!
    @IBOutlet private var statusLabel: UILabel!
    @IBOutlet private var genreLabel: UILabel!
    @IBOutlet private var updateAtLabel: UILabel!
    var presenter: ChaptersViewOutputProtocol!
    private lazy var titleLabel: MarqueeLabel = .init()
    private lazy var refreshControl: UIRefreshControl = .init()
    private lazy var downloadBarButtonItem: UIBarButtonItem = .init(image: #imageLiteral(resourceName: "ic_toolbar_download"), style: .plain, target: nil, action: nil)
    private lazy var scrollBarButtonItem: UIBarButtonItem = .init(image: #imageLiteral(resourceName: "ic_arrow_down"), style: .plain, target: nil, action: nil)
    private lazy var favoriteBarButtonItem: UIBarButtonItem = .init(image: #imageLiteral(resourceName: "ic_toolbar_favorite_outline"), style: .plain, target: nil, action: nil)

    private var book: Book?
    private var chapters: [Chapter] = []

    // MARK: - Public instance methods

    func reload(book: Book) {
        titleLabel.text = book.title
        refreshControl.endRefreshing()
        coverImageView.kf.setImage(with: URL(string: book.thumbnailUrl ?? ""), options: [.requestModifier(book.source.imageDownloadRequestModifier)])
        summaryTextView.text = book.summary
        authorLabel.text = book.author
        statusLabel.text = book.serialState.rawValue
        genreLabel.text = book.genre
        updateAtLabel.text = chapters.compactMap { $0.updateAt }.sorted(by: { $0 < $1 }).last?.convert2String(dateFormat: "yyyy-MM-dd")
        favoriteBarButtonItem.tintColor = book.isFavorite ? UIColor.flat.favorite : UIColor.flat.tint
        favoriteBarButtonItem.image = book.isFavorite ? #imageLiteral(resourceName: "ic_toolbar_favorite") : #imageLiteral(resourceName: "ic_toolbar_favorite_outline")
    }

    func reload(chapters: [Chapter]) {
        collectionView.reload(using: .init(source: self.chapters, target: chapters)) { self.chapters = $0 }
    }

    // MARK: - Overrides

    deinit { Logger.info() }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.isToolbarHidden = false
        setToolbarItems([downloadBarButtonItem, .flexibleSpace, favoriteBarButtonItem, .flexibleSpace, scrollBarButtonItem], animated: true)
        collectionView.indexPathsForSelectedItems?.forEach { collectionView.deselectItem(at: $0, animated: true) }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.contentInset = .init(top: infoContainerView.frame.maxY + 4 - view.safeAreaInsets.top, left: 8, bottom: 8, right: 8)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setToolbarItems([], animated: true)
        navigationController?.isToolbarHidden = true
    }

    // MARK: - Private instance methods

    private func setup() {
        setupView()
        setupBinding()
    }

    private func setupView() {
        titleLabel.font = .boldSystemFont(ofSize: 17)
        titleLabel.type = .continuous
        titleLabel.speed = .duration(4)
        titleLabel.animationCurve = .linear
        titleLabel.fadeLength = 4
        titleLabel.leadingBuffer = 4
        titleLabel.trailingBuffer = 4
        navigationItem.titleView = {
            /// https://stackoverflow.com/questions/20094198
            $0.addSubview($1)
            $1.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                $1.centerXAnchor.constraint(equalTo: $0.centerXAnchor),
                $1.centerYAnchor.constraint(equalTo: $0.centerYAnchor),
                $1.widthAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.width / 2),
            ])
            return $0
        }(UIView(), titleLabel)
        titleLabel.text = "Chapters"

        collectionView.refreshControl = refreshControl
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        collectionView.contentInset = .init(top: 8, left: 8, bottom: 8, right: 8)
        collectionView.registerCell(ChapterCollectionViewCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self

        infoContainerView.isOpaque = false
        infoContainerView.backgroundColor = UIColor.flat.background

        coverImageView.contentMode = .scaleAspectFill
        coverImageView.layer.cornerRadius = 8.0
        coverImageView.layer.masksToBounds = true

        summaryTextView.isEditable = false
        summaryTextView.backgroundColor = UIColor.flat.background
        summaryTextView.showsVerticalScrollIndicator = false
        summaryTextView.showsHorizontalScrollIndicator = false
        summaryTextView.font = .preferredFont(forTextStyle: .body)

        authorLabel.font = .preferredFont(forTextStyle: .caption1)
        statusLabel.font = .preferredFont(forTextStyle: .caption2)
        genreLabel.font = .preferredFont(forTextStyle: .caption2)
        updateAtLabel.font = .preferredFont(forTextStyle: .caption2)
    }

    private func setupBinding() {
        refreshControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] in self?.presenter.fetch() })
            .disposed(by: bag)
        favoriteBarButtonItem.rx.tap
            .subscribe(onNext: { [weak self] in self?.presenter.setFavorite() })
            .disposed(by: bag)
        let scrollToBottom: BehaviorSubject<Bool> = .init(value: true)
        collectionView.rx.contentOffset
            .compactMap { [weak self] offset -> Bool? in
                guard let collectionView = self?.collectionView, !(self?.chapters.isEmpty ?? true) else { return nil }
                return offset.y + collectionView.contentInset.top < collectionView.contentSize.height / 2
            }
            .bind(to: scrollToBottom)
            .disposed(by: bag)
        scrollToBottom.map { $0 ? #imageLiteral(resourceName: "ic_arrow_down") : #imageLiteral(resourceName: "ic_arrow_up") }
            .bind(to: scrollBarButtonItem.rx.image)
            .disposed(by: bag)
        scrollBarButtonItem.rx.tap
            .withLatestFrom(scrollToBottom)
            .subscribe(onNext: { [weak self] in
                guard let collectionView = self?.collectionView else { return }
                let offsetX = 0 - collectionView.contentInset.left
                let topY = 0 - collectionView.contentInset.top
                var bottomY = collectionView.contentSize.height + collectionView.contentInset.bottom - collectionView.frame.height
                bottomY = (bottomY + collectionView.contentInset.top > 0) ? bottomY : topY
                let offsetY = !$0 ? topY : bottomY
                collectionView.setContentOffset(.init(x: offsetX, y: offsetY), animated: true)
            })
            .disposed(by: bag)
    }
}

// MARK: - UICollectionViewDataSource

extension ChaptersViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return chapters.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChapterCollectionViewCell.reusableIdentifier, for: indexPath)
        if let cell = cell as? ChapterCollectionViewCell {
            cell.setup(chapters[indexPath.item])
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ChaptersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.showPagesView(where: chapters[indexPath.item])
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        return 4
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumInteritemSpacingForSectionAt _: Int) -> CGFloat {
        return 4
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemCountPerRow: CGFloat = 3
        let width = (collectionView.frame.size.width - collectionView.contentInset.left - collectionView.contentInset.right - (itemCountPerRow - 1) * self.collectionView(collectionView, layout: collectionViewLayout, minimumInteritemSpacingForSectionAt: indexPath.section)) / itemCountPerRow
        let height = UIFont.preferredFont(forTextStyle: .caption1).textSize().height + 16
        return .init(width: width, height: height)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let alpha = max(0, min(1, 0 - scrollView.contentOffset.y / collectionView.contentInset.top))
        infoContainerView.alpha = alpha
    }
}
