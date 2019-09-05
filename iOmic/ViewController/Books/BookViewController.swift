//
//  BookViewController.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/9/5.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import RxCocoa
import RxDataSources
import RxSwift
import UIKit

protocol BookViewCoordinator: AnyObject {}

class BookViewController: UIViewController {
    // MARK: - instance props.

    private let bag: DisposeBag = .init()
    private weak var coordinator: BookViewCoordinator?
    private let viewModel: BookViewModel
    private lazy var refreshControl: UIRefreshControl = .init()
    private let dataSource: RxCollectionViewSectionedAnimatedDataSource<AnimatableSectionModel<Int, Chapter>> = .init(configureCell: { _, collectionView, indexPath, chapter in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChapterCollectionViewCell.reusableIdentifier, for: indexPath)
        if let cell = cell as? ChapterCollectionViewCell { cell.titleLabel.text = chapter.name }
        return cell
    })
    @IBOutlet var collectionView: UICollectionView!

    // MARK: - public instance methods

    init(coordinator: BookViewCoordinator, viewModel: BookViewModel) {
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
        collectionView.collectionViewLayout = {
            let layout = UICollectionViewFlowLayout()
            layout.estimatedItemSize = .init(width: 80, height: 30)
            return layout
        }()
        collectionView.registerCell(ChapterCollectionViewCell.self)
    }

    private func setupBinding() {
        viewModel.chapters.map { [AnimatableSectionModel<Int, Chapter>(model: 0, items: $0)] }.bind(to: collectionView.rx.items(dataSource: dataSource)).disposed(by: bag)
    }
}
