//
//  ChaptersViewController.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/9/5.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation
import Hue
import Kingfisher
import MarqueeLabel
import RxCocoa
import RxDataSources
import RxSwift
import UIKit

protocol ChaptersViewCoordinator: PushedViewCoordinator {
    func showChapter(_ chapter: Chapter)
}

class ChaptersViewController: UIViewController {
    // MARK: - instance props.

    private let bag: DisposeBag = .init()
    private weak var coordinator: ChaptersViewCoordinator?
    private let viewModel: ChaptersViewModel
    private lazy var titleLabel: MarqueeLabel = .init()
    private lazy var downloadBarButtonItem: UIBarButtonItem = .init(image: #imageLiteral(resourceName: "ic_navigationbar_download_outline"), style: .plain, target: nil, action: nil)
    private lazy var topBottomBarButtonItem: UIBarButtonItem = .init(image: #imageLiteral(resourceName: "ic_bar_drop_down"), style: .plain, target: nil, action: nil)
    private lazy var favoriteBarButtonItem: UIBarButtonItem = .init(image: #imageLiteral(resourceName: "ic_navigationbar_favorite_outline"), style: .plain, target: nil, action: nil)
    private lazy var refreshControl: UIRefreshControl = .init()
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var headerContainerView: UIView!
    @IBOutlet var coverImageView: UIImageView!
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var genreLabel: UILabel!
    @IBOutlet var updateAtLabel: UILabel!
    private let dataSource: RxCollectionViewSectionedAnimatedDataSource<AnimatableSectionModel<Int, Chapter>> = .init(configureCell: { _, collectionView, indexPath, chapter in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChapterCollectionViewCell.reusableIdentifier, for: indexPath)
        if let cell = cell as? ChapterCollectionViewCell { cell.titleLabel.text = chapter.name }
        return cell
    })

    // MARK: - public instance methods

    init(coordinator: ChaptersViewCoordinator, viewModel: ChaptersViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit { print(String(describing: self)) }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
        setupBinding()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.isToolbarHidden = false
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // !!!: - the safeAreaInsets would be zero in viewDidLoad
        collectionView.contentInset = .init(top: headerContainerView.frame.maxY + 4 - view.safeAreaInsets.top, left: 8, bottom: 8, right: 8)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.isToolbarHidden = true
        if isMovingFromParent { coordinator?.movingFromParent() }
    }

    // MARK: - private instance methods

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
            let view = UIView()
            view.addSubview(titleLabel)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                titleLabel.widthAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.width / 2),
            ])
            return view
        }()

        // TODO: - implement for downloadBarButtonItem
        setToolbarItems([.flexibleSpace, downloadBarButtonItem, .flexibleSpace, favoriteBarButtonItem, .flexibleSpace, topBottomBarButtonItem, .flexibleSpace], animated: true)

        collectionView.refreshControl = refreshControl
        collectionView.registerCell(ChapterCollectionViewCell.self)

        headerContainerView.isOpaque = false
        headerContainerView.backgroundColor = UIColor.flat.background
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.layer.cornerRadius = 8.0
        coverImageView.layer.masksToBounds = true
        descriptionTextView.isEditable = false
        descriptionTextView.backgroundColor = UIColor.flat.background
        descriptionTextView.showsVerticalScrollIndicator = false
        descriptionTextView.showsHorizontalScrollIndicator = false
        descriptionTextView.font = .preferredFont(forTextStyle: .body)
        authorLabel.font = .preferredFont(forTextStyle: .caption1)
        statusLabel.font = .preferredFont(forTextStyle: .caption2)
        genreLabel.font = .preferredFont(forTextStyle: .caption2)
        updateAtLabel.font = .preferredFont(forTextStyle: .caption2)
    }

    private func setupBinding() {
        viewModel.error.subscribe(onNext: { [weak self] in self?.coordinator?.whoops($0) }).disposed(by: bag)

        viewModel.isFavorited.map { $0 ? UIColor.flat.favorite : UIColor.flat.tint }.bind(to: favoriteBarButtonItem.rx.tintColor).disposed(by: bag)
        viewModel.isFavorited.map { $0 ? #imageLiteral(resourceName: "ic_navigationbar_favorite") : #imageLiteral(resourceName: "ic_navigationbar_favorite_outline") }.bind(to: favoriteBarButtonItem.rx.image).disposed(by: bag)
        favoriteBarButtonItem.rx.tap.withLatestFrom(viewModel.isFavorited) { !$1 }.bind(to: viewModel.isFavorited).disposed(by: bag)
        favoriteBarButtonItem.rx.tap.bind(to: viewModel.switchFavorited).disposed(by: bag)
        topBottomBarButtonItem.rx.tap.subscribe(onNext: { [weak self] in self?.scrollToCollectionViewEdge() }).disposed(by: bag)
        viewModel.book.subscribe(onNext: { [weak self] book in self?.coverImageView.kf.setImage(with: URL(string: book.thumbnailUrl ?? ""), options: [.transition(.fade(0.2)), .requestModifier(book.source.modifier), .scaleFactor(UIScreen.main.scale), .cacheOriginalImage]) }).disposed(by: bag)
        viewModel.book.map { $0.summary }.bind(to: descriptionTextView.rx.text).disposed(by: bag)
        viewModel.book.map { $0.author }.bind(to: authorLabel.rx.text).disposed(by: bag)
        viewModel.book.map { $0.status.rawValue }.bind(to: statusLabel.rx.text).disposed(by: bag)
        viewModel.book.map { $0.genre }.bind(to: genreLabel.rx.text).disposed(by: bag)
        refreshControl.rx.controlEvent(.valueChanged).bind(to: viewModel.load).disposed(by: bag)
        viewModel.chapters.subscribe(onNext: { [weak self] _ in self?.refreshControl.endRefreshing() }).disposed(by: bag)
        viewModel.book.map { $0.title }.bind(to: titleLabel.rx.text).disposed(by: bag)
        collectionView.rx.setDelegate(self).disposed(by: bag)
        collectionView.rx.itemSelected.withLatestFrom(viewModel.chapters) { $1[$0.item] }.subscribe(onNext: { [weak self] in self?.coordinator?.showChapter($0) }).disposed(by: bag)
        viewModel.chapters.compactMap { chapters in chapters.compactMap { $0.updateAt }.sorted(by: { $0 < $1 }).last?.convert2String(dateFormat: "yyyy-MM-dd") }.bind(to: updateAtLabel.rx.text).disposed(by: bag)
        viewModel.chapters.map { [AnimatableSectionModel<Int, Chapter>(model: 0, items: $0)] }.bind(to: collectionView.rx.items(dataSource: dataSource)).disposed(by: bag)
    }

    private func scrollToCollectionViewEdge() {
        let offsetX = 0 - collectionView.contentInset.left
        let topY = 0 - collectionView.contentInset.top
        var bottomY = collectionView.contentSize.height + collectionView.contentInset.bottom - collectionView.frame.height
        bottomY = (bottomY + collectionView.contentInset.top > 0) ? bottomY : topY
        let offsetY = (collectionView.contentOffset.y + collectionView.contentInset.top - collectionView.contentSize.height / 2) > 0 ? topY : bottomY
        collectionView.setContentOffset(.init(x: offsetX, y: offsetY), animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ChaptersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        return 4
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumInteritemSpacingForSectionAt _: Int) -> CGFloat {
        return 4
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemCountPerRow = 3
        let width = (collectionView.frame.size.width - collectionView.contentInset.left - collectionView.contentInset.right - CGFloat(itemCountPerRow - 1) * self.collectionView(collectionView, layout: collectionViewLayout, minimumInteritemSpacingForSectionAt: indexPath.section)) / CGFloat(itemCountPerRow)
        let height = UIFont.preferredFont(forTextStyle: .caption1).textSize().height + 16
        return .init(width: width, height: height)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let alpha = max(0, min(1, 0 - scrollView.contentOffset.y / collectionView.contentInset.top))
        headerContainerView.alpha = alpha
    }
}
