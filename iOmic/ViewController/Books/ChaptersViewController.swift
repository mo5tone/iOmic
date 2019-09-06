//
//  ChaptersViewController.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/9/5.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import MarqueeLabel
import RxCocoa
import RxDataSources
import RxSwift
import UIKit

protocol ChaptersViewCoordinator: AnyObject {}

class ChaptersViewController: UIViewController {
    // MARK: - instance props.

    private let bag: DisposeBag = .init()
    private weak var coordinator: ChaptersViewCoordinator?
    private let viewModel: ChaptersViewModel
    private lazy var titleLabel: MarqueeLabel = .init()
    private lazy var refreshControl: UIRefreshControl = .init()
    @IBOutlet var collectionView: UICollectionView!
    private lazy var coverImageView: UIImageView = .init()
    private let coverImageViewAspectRatio: CGFloat = 16 / 9
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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
        setupBinding()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.setBackgroundImage(.init(), for: .default)
        navigationController?.navigationBar.shadowImage = .init()
        navigationController?.navigationBar.isTranslucent = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // !!!: - the safeAreaInsets would be zero in viewDidLoad
        let coverImageViewHeight = coverImageView.frame.size.height
        collectionView.contentInset = .init(top: coverImageViewHeight + 8 - view.safeAreaInsets.top, left: 8, bottom: 8, right: 8)
        view.constraints.filter { $0.firstAttribute == .top && $0.firstItem === coverImageView }.first?.constant = 0 - view.safeAreaInsets.top
    }

    // MARK: - private instance methods

    private func setupView() {
        titleLabel.font = .boldSystemFont(ofSize: 17)
        titleLabel.textColor = .darkText
        titleLabel.type = .continuous
        titleLabel.speed = .duration(3)
        titleLabel.animationCurve = .easeInOut
        titleLabel.fadeLength = 4
        titleLabel.leadingBuffer = 8
        navigationItem.titleView = titleLabel

        view.addSubview(coverImageView)
        coverImageView.isOpaque = false
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.clipsToBounds = true
        coverImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            coverImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            coverImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            coverImageView.heightAnchor.constraint(equalTo: coverImageView.widthAnchor, multiplier: 1 / coverImageViewAspectRatio),
            coverImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0 - view.safeAreaInsets.top),
        ])
        collectionView.backgroundColor = .groupTableViewBackground
        collectionView.refreshControl = refreshControl
        collectionView.registerCell(ChapterCollectionViewCell.self)
    }

    private func setupBinding() {
        viewModel.book.compactMap { $0.thumbnailUrl }.subscribe(onNext: { [weak self] in self?.coverImageView.kf.setImage(with: URL(string: $0)) }).disposed(by: bag)
        refreshControl.rx.controlEvent(.valueChanged).bind(to: viewModel.load).disposed(by: bag)
        viewModel.chapters.subscribe(onNext: { [weak self] _ in self?.refreshControl.endRefreshing() }).disposed(by: bag)
        viewModel.book.map { $0.title }.bind(to: titleLabel.rx.text).disposed(by: bag)
        collectionView.rx.setDelegate(self).disposed(by: bag)
        viewModel.chapters.map { [AnimatableSectionModel<Int, Chapter>(model: 0, items: $0)] }.bind(to: collectionView.rx.items(dataSource: dataSource)).disposed(by: bag)
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
        let itemCountPerRow = 4
        let width = (collectionView.frame.size.width - collectionView.contentInset.left - collectionView.contentInset.right - CGFloat(itemCountPerRow - 1) * self.collectionView(collectionView, layout: collectionViewLayout, minimumInteritemSpacingForSectionAt: indexPath.section)) / CGFloat(itemCountPerRow)
        let height = UIFont.preferredFont(forTextStyle: .caption1).textSize().height + 8
        return .init(width: width, height: height)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // TODO: - Try to scale the image view
        coverImageView.alpha = max(0, min(1, 0 - scrollView.contentOffset.y / collectionView.contentInset.top))
    }
}
