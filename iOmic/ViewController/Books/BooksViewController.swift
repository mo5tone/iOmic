//
//  BooksViewController.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/8/24.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Kingfisher
import RxDataSources
import RxSwift
import UIKit

protocol BooksViewCoordinator: VisibleViewCoordinator {
    func showChapters(in book: Book)
}

class BooksViewController: UIViewController {
    // MARK: - props.

    private let bag: DisposeBag = .init()
    private weak var coordinator: BooksViewCoordinator?
    private var viewModel: BooksViewModel
    private lazy var segmentedControl: UISegmentedControl = .init(items: ["Favorite", "History"])
    private lazy var addBarButtonItem: UIBarButtonItem = .init(barButtonSystemItem: .add, target: nil, action: nil)
    @IBOutlet var collectionView: UICollectionView!
    private let dataSource: RxCollectionViewSectionedAnimatedDataSource<AnimatableSectionModel<SourceIdentifier, Book>> = .init(
        configureCell: { _, collectionView, indexPath, book in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCollectionViewCell.reusableIdentifier, for: indexPath)
            if let cell = cell as? BookCollectionViewCell { cell.setup(book: book) }
            return cell
        },
        configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else { return UICollectionReusableView() }
            let supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: BookCollectionHeader.reusableIdentifier, for: indexPath)
            if let supplementaryView = supplementaryView as? BookCollectionHeader { supplementaryView.setup(identifier: dataSource.sectionModels[indexPath.section].model) }
            return supplementaryView
        }
    )

    // MARK: - public instance methods

    init(coordinator: BooksViewCoordinator, viewModel: BooksViewModel) {
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
        navigationController?.navigationBar.prefersLargeTitles = true
        viewModel.load.on(.next(()))
    }

    // MARK: - private instance methods

    private func setupView() {
        segmentedControl.selectedSegmentIndex = 0

        navigationItem.title = "Books"
        navigationItem.leftBarButtonItem = addBarButtonItem
        navigationItem.titleView = segmentedControl

        collectionView.contentInset = .init(top: 8, left: 8, bottom: 8, right: 8)
        collectionView.registerHeaderFooterView(BookCollectionHeader.self, supplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
        collectionView.registerCell(BookCollectionViewCell.self)
    }

    private func setupBinding() {
        viewModel.error.subscribe(onNext: { [weak self] in self?.coordinator?.whoops($0) }).disposed(by: bag)

        addBarButtonItem.rx.tap.bind(to: viewModel.add).disposed(by: bag)

        segmentedControl.rx.selectedSegmentIndex.bind(to: viewModel.segmentIndex).disposed(by: bag)

        viewModel.books.map { $0.map { .init(model: $0.0, items: $0.1) } }.bind(to: collectionView.rx.items(dataSource: dataSource)).disposed(by: bag)
        collectionView.rx.prefetchItems.withLatestFrom(viewModel.books) { indexPaths, books in indexPaths.map { books[$0.section].1[$0.item] } }.subscribe(onNext: { [weak self] in self?.prefetchItems($0) }).disposed(by: bag)
        collectionView.rx.cancelPrefetchingForItems.withLatestFrom(viewModel.books) { indexPaths, books in indexPaths.map { books[$0.section].1[$0.item] } }.subscribe(onNext: { [weak self] in self?.cancelPrefetchingForItems($0) }).disposed(by: bag)

        collectionView.rx.setDelegate(self).disposed(by: bag)
        collectionView.rx.itemSelected.withLatestFrom(viewModel.books) { $1[$0.section].1[$0.item] }.subscribe(onNext: { [weak self] in self?.coordinator?.showChapters(in: $0) }).disposed(by: bag)
        collectionView.rx.willDisplayCell.subscribe(onNext: { [weak self] cell, _ in self?.willDisplayCell(cell) }).disposed(by: bag)
        collectionView.rx.didEndDisplayingCell.compactMap { $0.cell as? BookCollectionViewCell }.subscribe(onNext: { $0.imageView?.kf.cancelDownloadTask() }).disposed(by: bag)
    }

    private func prefetchItems(_ books: [Book]) {
        guard let source = books.first?.source else { return }
        ImagePrefetcher(resources: books.compactMap { URL(string: $0.thumbnailUrl ?? "") }, options: [.requestModifier(source.modifier)]).start()
    }

    private func cancelPrefetchingForItems(_ books: [Book]) {
        guard let source = books.first?.source else { return }
        ImagePrefetcher(resources: books.compactMap { URL(string: $0.thumbnailUrl ?? "") }, options: [.requestModifier(source.modifier)]).stop()
    }

    private func willDisplayCell(_ cell: UICollectionViewCell) {
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
}

// MARK: - UICollectionViewDelegateFlowLayout

extension BooksViewController: UICollectionViewDelegateFlowLayout {
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
