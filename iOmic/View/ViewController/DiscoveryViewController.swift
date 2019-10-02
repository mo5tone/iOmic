//
//  DiscoveryViewController.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/9/29.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import DifferenceKit
import Kingfisher
import RxSwift
import UIKit

class DiscoveryViewController: UIViewController, DiscoveryViewProtocol {
    // MARK: - Instance properties

    private let bag: DisposeBag = .init()
    @IBOutlet private var collectionView: UICollectionView!
    var presenter: DiscoveryViewOutputProtocol!
    private lazy var sourceBarButtonItem: UIBarButtonItem = .init(image: #imageLiteral(resourceName: "ic_navigationbar_tune"), style: .plain, target: nil, action: nil)
    private lazy var updatedTimeBarButtonItem: UIBarButtonItem = .init(image: #imageLiteral(resourceName: "ic_time_outline"), style: .plain, target: nil, action: nil)
    private lazy var searchController: UISearchController = .init(searchResultsController: nil)
    private lazy var refreshControl: UIRefreshControl = .init()
    private var books: [Book] = []

    // MARK: Public instance methods

    func reload(source: Source, more: Bool, books: [Book]) {
        navigationItem.title = source.name
        refreshControl.endRefreshing()
        var target = books
        if more { target.insert(contentsOf: self.books, at: 0) }
        collectionView.reload(using: .init(source: self.books, target: target)) { self.books = $0 }
    }

    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    // MARK: - Private instance methods

    private func setup() {
        setupView()
        setupBinding()
    }

    private func setupView() {
        navigationItem.leftBarButtonItem = sourceBarButtonItem
        navigationItem.title = "Discovery"
        navigationItem.rightBarButtonItem = updatedTimeBarButtonItem

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Keyword"
        navigationItem.searchController = searchController
        definesPresentationContext = true

        collectionView.refreshControl = refreshControl
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        collectionView.contentInset = .init(top: 8, left: 8, bottom: 8, right: 8)
        collectionView.registerCell(BookCollectionViewCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
    }

    private func setupBinding() {
        let query: BehaviorSubject<String> = .init(value: "")
        let fetchingSort: BehaviorSubject<Source.FetchingSort> = .init(value: .popularity)
        fetchingSort.map { $0 == .popularity ? #imageLiteral(resourceName: "ic_time_outline") : #imageLiteral(resourceName: "ic_time") }
            .bind(to: updatedTimeBarButtonItem.rx.image)
            .disposed(by: bag)
        sourceBarButtonItem.rx.tap
            .throttle(.milliseconds(200), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in self?.presenter.presentSourcesView() })
            .disposed(by: bag)
        updatedTimeBarButtonItem.rx.tap
            .throttle(.milliseconds(200), scheduler: MainScheduler.instance)
            .withLatestFrom(fetchingSort)
            .subscribe(onNext: { fetchingSort.on(.next($0 == .popularity ? .updatedDate : .popularity)) })
            .disposed(by: bag)
        searchController.searchBar.rx.text
            .map { $0 ?? "" }
            .bind(to: query)
            .disposed(by: bag)
        searchController.searchBar.rx.cancelButtonClicked
            .map { _ in "" }
            .bind(to: query)
            .disposed(by: bag)
        let refresh = Observable.merge([updatedTimeBarButtonItem.rx.tap, searchController.searchBar.rx.searchButtonClicked, searchController.searchBar.rx.cancelButtonClicked, refreshControl.rx.controlEvent(.valueChanged)].map { $0.asObservable() })
        let loadMore = collectionView.rx.loadMore(when: 100)
        refresh.withLatestFrom(Observable.combineLatest(query, fetchingSort))
            .subscribe(onNext: { [weak self] query, fetchingSort in self?.presenter.loadContent(where: query, sortedBy: fetchingSort, refresh: true) })
            .disposed(by: bag)
        loadMore.withLatestFrom(Observable.combineLatest(query, fetchingSort))
            .subscribe(onNext: { [weak self] query, fetchingSort in self?.presenter.loadContent(where: query, sortedBy: fetchingSort, refresh: false) })
            .disposed(by: bag)
    }
}

// MARK: - UISearchResultsUpdating

extension DiscoveryViewController: UISearchResultsUpdating {
    func updateSearchResults(for _: UISearchController) {}
}

// MARK: - UICollectionViewDataSource

extension DiscoveryViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return books.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCollectionViewCell.reusableIdentifier, for: indexPath)
        if let cell = cell as? BookCollectionViewCell {
            cell.setup(book: books[indexPath.item])
        }
        return cell
    }
}

// MARK: - UICollectionViewDataSourcePrefetching

extension DiscoveryViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let prefetchingItems = indexPaths.map { books[$0.item] }
        Source.values
            .map { source in (source, prefetchingItems.filter { $0.source == source }.compactMap { URL(string: $0.thumbnailUrl ?? "") }) }
            .forEach { source, resources in ImagePrefetcher(resources: resources, options: [.requestModifier(source.imageDownloadRequestModifier)]).start() }
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
