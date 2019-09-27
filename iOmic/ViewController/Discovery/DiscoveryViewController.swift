//
//  DiscoveryViewController.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/8/24.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Kingfisher
import RxCocoa
import RxDataSources
import RxSwift
import UIKit

protocol DiscoveryViewCoordinator: VisibleViewCoordinator {
    func presentSources(current: SourceProtocol) -> Observable<SourceProtocol>
    func presentFilters(current: [FilterProrocol]) -> Observable<[FilterProrocol]>
    func showChapters(in book: Book)
}

class DiscoveryViewController: UIViewController {
    // MARK: - instance props.

    private weak var coordinator: DiscoveryViewCoordinator?
    private let viewModel: DiscoveryViewModel
    private let bag: DisposeBag = .init()
    private lazy var refreshControl: UIRefreshControl = .init()
    private lazy var searchController: UISearchController = .init(searchResultsController: nil)
    private let dataSource: RxCollectionViewSectionedAnimatedDataSource<AnimatableSectionModel<Int, Book>> = .init(configureCell: { _, collectionView, indexPath, book in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCollectionViewCell.reusableIdentifier, for: indexPath)
        if let cell = cell as? BookCollectionViewCell {
            cell.setup(book: book)
        }
        return cell
    })
    @IBOutlet private var collectionView: UICollectionView!

    // MARK: - Private instance methods

    private func setupView() {
        navigationItem.leftBarButtonItem = .init(image: #imageLiteral(resourceName: "ic_navigationbar_tune"), style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = .init(image: #imageLiteral(resourceName: "ic_navigationbar_filter"), style: .plain, target: nil, action: nil)
        navigationItem.searchController = searchController

        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Keywords here"
        definesPresentationContext = true

        collectionView.refreshControl = refreshControl
        collectionView.contentInset = .init(top: 8, left: 8, bottom: 8, right: 8)
        collectionView.registerCell(BookCollectionViewCell.self)
    }

    private func setupBinding() {
        viewModel.error.subscribe(onNext: { [weak self] in self?.coordinator?.whoops($0) }).disposed(by: bag)

        viewModel.title.bind(to: navigationItem.rx.title).disposed(by: bag)
        navigationItem.leftBarButtonItem?.rx.tap
            .withLatestFrom(viewModel.source)
            .flatMapLatest { [weak self] in self?.coordinator?.presentSources(current: $0) ?? Observable.empty() }
            .bind(to: viewModel.source)
            .disposed(by: bag)
        let filtersChanged = navigationItem.rightBarButtonItem?.rx.tap
            .withLatestFrom(viewModel.filters)
            .flatMapLatest { [weak self] in self?.coordinator?.presentFilters(current: $0) ?? Observable.empty() }
            .share()
        filtersChanged?.bind(to: viewModel.filters).disposed(by: bag)
        filtersChanged?.map { _ in }.bind(to: viewModel.load).disposed(by: bag)
        searchController.searchBar.rx.text.bind(to: viewModel.query).disposed(by: bag)
        searchController.searchBar.rx.cancelButtonClicked.map { _ in nil }.bind(to: viewModel.query).disposed(by: bag)

        let loadControlEvents = [refreshControl.rx.controlEvent(.valueChanged), searchController.searchBar.rx.searchButtonClicked, searchController.searchBar.rx.cancelButtonClicked]
        Observable.merge(loadControlEvents.map { $0.asObservable() }).bind(to: viewModel.load).disposed(by: bag)

        // !!!: https://github.com/onevcat/Kingfisher/issues/1230
        collectionView.rx.prefetchItems.withLatestFrom(viewModel.books) { indexPaths, books in indexPaths.filter { $0.item < books.count }.map { books[$0.item] } }.subscribe(onNext: { [weak self] in self?.prefetchItems($0) }).disposed(by: bag)
        collectionView.rx.cancelPrefetchingForItems.withLatestFrom(viewModel.books) { indexPaths, books in indexPaths.filter { $0.item < books.count }.map { books[$0.item] } }.subscribe(onNext: { [weak self] in self?.cancelPrefetchingForItems($0) }).disposed(by: bag)

        collectionView.rx.setDelegate(self).disposed(by: bag)
        collectionView.rx.itemSelected.withLatestFrom(viewModel.books) { $1[$0.item] }.subscribe(onNext: { [weak self] in self?.coordinator?.showChapters(in: $0) }).disposed(by: bag)
        collectionView.rx.willDisplayCell.map { $1 }.withLatestFrom(viewModel.books.map { $0.count }) { $0.item == $1 - 1 }.filter { $0 }.map { _ in () }.bind(to: viewModel.loadMore).disposed(by: bag)

        viewModel.books.map { _ in false }.bind(to: refreshControl.rx.isRefreshing).disposed(by: bag)
        viewModel.books.map { [AnimatableSectionModel<Int, Book>(model: 0, items: $0)] }.bind(to: collectionView.rx.items(dataSource: dataSource)).disposed(by: bag)
    }

    private func prefetchItems(_ books: [Book]) {
        guard let source = books.first?.source else { return }
        ImagePrefetcher(resources: books.compactMap { URL(string: $0.thumbnailUrl ?? "") }, options: [.requestModifier(source.modifier)]).start()
    }

    private func cancelPrefetchingForItems(_ books: [Book]) {
        guard let source = books.first?.source else { return }
        ImagePrefetcher(resources: books.compactMap { URL(string: $0.thumbnailUrl ?? "") }, options: [.requestModifier(source.modifier)]).stop()
    }

    // MARK: - Public instance methods

    init(coordinator: DiscoveryViewCoordinator, viewModel: DiscoveryViewModel) {
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
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
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
        return CGSize(width: width, height: height)
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        return 8
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumInteritemSpacingForSectionAt _: Int) -> CGFloat {
        return 8
    }
}
