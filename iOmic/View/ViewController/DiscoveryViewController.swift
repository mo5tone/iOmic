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
    private lazy var searchController: UISearchController = .init(searchResultsController: nil)
    private lazy var refreshControl: UIRefreshControl = .init()
    private var source: Source = .dongmanzhijia
    private var query: String = ""
    private var fetchingSort: Source.FetchingSort = .popularity
    private var books: [Book] = []

    // MARK: Public instance methods

    func update(source: Source, books: [Book]) {
        self.source = source
        navigationItem.title = source.name
        refreshControl.endRefreshing()
        collectionView.reload(using: .init(source: self.books, target: books)) { self.books = $0 }
    }

    func add(more books: [Book]) {
        var newBooks: [Book] = .init(self.books)
        newBooks.append(contentsOf: books)
        collectionView.reload(using: .init(source: self.books, target: newBooks)) { self.books = $0 }
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
        navigationItem.title = source.name

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
        sourceBarButtonItem.rx.tap
            .throttle(.milliseconds(200), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in self?.presenter.presentSourcesViewController() })
            .disposed(by: bag)
        searchController.searchBar.rx.searchButtonClicked
            .withLatestFrom(searchController.searchBar.rx.text)
            .subscribe(onNext: { [weak self] in self?.search(where: $0) })
            .disposed(by: bag)
        searchController.searchBar.rx.cancelButtonClicked
            .subscribe { [weak self] _ in self?.refresh() }
            .disposed(by: bag)
        refreshControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] in self?.refresh() })
            .disposed(by: bag)
    }

    private func refresh() {
        query = ""
        fetchingSort = .popularity
        presenter.loadContent(where: query, sortedBy: fetchingSort, refresh: true)
    }

    private func search(where text: String?) {
        query = text ?? ""
        presenter.loadContent(where: query, sortedBy: fetchingSort, refresh: true)
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
        let resources = indexPaths.map { books[$0.item] }.compactMap { URL(string: $0.thumbnailUrl ?? "") }
        ImagePrefetcher(resources: resources, options: [.requestModifier(source.imageDownloadRequestModifier)]).start()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension DiscoveryViewController: UICollectionViewDelegateFlowLayout {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y - max(0, scrollView.contentSize.height - scrollView.frame.height) > 100 {
            presenter.loadContent(where: query, sortedBy: fetchingSort, refresh: false)
        }
    }

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
