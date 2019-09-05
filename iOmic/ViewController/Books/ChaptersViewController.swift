//
//  ChaptersViewController.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/9/5.
//  Copyright © 2019 门捷夫. All rights reserved.
//

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
    private lazy var refreshControl: UIRefreshControl = .init()
    private let dataSource: RxCollectionViewSectionedAnimatedDataSource<AnimatableSectionModel<Int, Chapter>> = .init(configureCell: { _, collectionView, indexPath, chapter in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChapterCollectionViewCell.reusableIdentifier, for: indexPath)
        if let cell = cell as? ChapterCollectionViewCell { cell.titleLabel.text = chapter.name }
        return cell
    })
    @IBOutlet var collectionView: UICollectionView!

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

    // MARK: - private instance methods

    private func setupView() {
        collectionView.contentInset = .init(top: UIScreen.main.bounds.size.width, left: 8, bottom: 8, right: 8)
        collectionView.refreshControl = refreshControl
        collectionView.rx.setDelegate(self)
        collectionView.registerCell(ChapterCollectionViewCell.self)
    }

    private func setupBinding() {
        viewModel.chapters.map { [AnimatableSectionModel<Int, Chapter>(model: 0, items: $0)] }.bind(to: collectionView.rx.items(dataSource: dataSource)).disposed(by: bag)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ChaptersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        return 8
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumInteritemSpacingForSectionAt _: Int) -> CGFloat {
        return 8
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemCountPerRow = 4
        let width = (collectionView.frame.size.width - collectionView.contentInset.left - collectionView.contentInset.right - CGFloat(itemCountPerRow - 1) * self.collectionView(collectionView, layout: collectionViewLayout, minimumInteritemSpacingForSectionAt: indexPath.section)) / CGFloat(itemCountPerRow)
        let height = UIFont.preferredFont(forTextStyle: .caption1).textSize().height + 8
        return .init(width: width, height: height)
    }
}
