//
//  DiscoveryViewController.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/8/24.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import RxCocoa
import RxDataSources
import RxSwift
import SwiftEntryKit
import UIKit

protocol DiscoveryViewCoordinator: AnyObject {
    func popupSourcesSwitcher(current: SourceProtocol) -> Observable<SourceProtocol>
    func popupFiltersPicker(current: [FilterProrocol]) -> Observable<[FilterProrocol]>
    func showBookDetail(_ book: Book)
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
        if let cell = cell as? BookCollectionViewCell { cell.setup(book: book) }
        return cell
    })
    @IBOutlet var collectionView: UICollectionView!

    // MARK: - Private instance methods

    private func setupView() {
        navigationItem.leftBarButtonItem = .init(image: #imageLiteral(resourceName: "ic_tune"), style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = .init(image: #imageLiteral(resourceName: "ic_filter"), style: .plain, target: nil, action: nil)
        navigationItem.searchController = searchController

        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Keywords here"
        definesPresentationContext = true

        collectionView.backgroundColor = .groupTableViewBackground
        collectionView.refreshControl = refreshControl
        collectionView.contentInset = .init(top: 8, left: 8, bottom: 8, right: 8)
        collectionView.registerCell(BookCollectionViewCell.self)
    }

    private func setupBinding() {
        viewModel.title.bind(to: navigationItem.rx.title).disposed(by: bag)
        navigationItem.leftBarButtonItem?.rx.tap
            .withLatestFrom(viewModel.source)
            .flatMapLatest { [weak self] in self?.coordinator?.popupSourcesSwitcher(current: $0) ?? Observable.empty() }
            .bind(to: viewModel.source)
            .disposed(by: bag)
        let filtersChanged = navigationItem.rightBarButtonItem?.rx.tap
            .withLatestFrom(viewModel.filters)
            .flatMapLatest { [weak self] in self?.coordinator?.popupFiltersPicker(current: $0) ?? Observable.empty() }
            .share()
        filtersChanged?.bind(to: viewModel.filters).disposed(by: bag)
        filtersChanged?.map { _ in }.bind(to: viewModel.load).disposed(by: bag)
        searchController.searchBar.rx.text.bind(to: viewModel.query).disposed(by: bag)
        searchController.searchBar.rx.cancelButtonClicked.map { _ in nil }.bind(to: viewModel.query).disposed(by: bag)

        let loadControlEvents = [refreshControl.rx.controlEvent(.valueChanged), searchController.searchBar.rx.searchButtonClicked, searchController.searchBar.rx.cancelButtonClicked]
        Observable.merge(loadControlEvents.map { $0.asObservable() }).bind(to: viewModel.load).disposed(by: bag)

        collectionView.rx.setDelegate(self).disposed(by: bag)
        collectionView.rx.willDisplayCell.subscribe(onNext: { cell, _ in
            cell.contentView.layer.cornerRadius = 8.0
            cell.contentView.layer.borderWidth = 1.0
            cell.contentView.layer.borderColor = UIColor.clear.cgColor
            cell.contentView.layer.masksToBounds = true

            cell.layer.shadowColor = UIColor.lightGray.cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
            cell.layer.shadowRadius = 2.0
            cell.layer.shadowOpacity = 1.0
            cell.layer.masksToBounds = false
            cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        }).disposed(by: bag)
        collectionView.rx.willDisplayCell.map { $1 }.withLatestFrom(viewModel.books.map { $0.count }) { $0.item == $1 - 1 }.filter { $0 }.map { _ in () }.bind(to: viewModel.loadMore).disposed(by: bag)
        collectionView.rx.didEndDisplayingCell.compactMap { $0.cell as? BookCollectionViewCell }.subscribe(onNext: { $0.imageView?.kf.cancelDownloadTask() }).disposed(by: bag)

        viewModel.books.subscribe { [weak self] _ in self?.refreshControl.endRefreshing() }.disposed(by: bag)
        viewModel.books.map { [AnimatableSectionModel<Int, Book>(model: 0, items: $0)] }.bind(to: collectionView.rx.items(dataSource: dataSource)).disposed(by: bag)
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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupView()
        setupBinding()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension DiscoveryViewController: UICollectionViewDelegateFlowLayout {
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
