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
import UIKit

protocol DiscoveryViewCoordinator: AnyObject {}

class DiscoveryViewController: UIViewController {
    // MARK: - props.

    private weak var coordinator: DiscoveryViewCoordinator?
    private var viewModel: DiscoveryViewModel
    private let disposeBag = DisposeBag()
    private lazy var refreshControl = UIRefreshControl()
    private let searchController = UISearchController(searchResultsController: nil)
    private let dataSource = RxCollectionViewSectionedAnimatedDataSource<AnimatableSectionModel<Int, Book>>(configureCell: { _, collectionView, indexPath, book in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCollectionViewCell.reusableIdentifier, for: indexPath)
        if let cell = cell as? BookCollectionViewCell { cell.setup(book: book) }
        return cell
    })
    @IBOutlet var collectionView: UICollectionView!

    // MARK: - Private methods

    private func setupView() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_filter"), style: .plain, target: self, action: #selector(popupFiltersView))
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Keywords here"
        navigationItem.searchController = searchController
        definesPresentationContext = true

        collectionView.refreshControl = refreshControl
        collectionView.backgroundColor = .black
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        collectionView.registerCell(BookCollectionViewCell.self)
    }

    private func setupBinding() {
        viewModel.title.bind(to: navigationItem.rx.title).disposed(by: disposeBag)

        searchController.searchBar.rx.text.bind(to: viewModel.query).disposed(by: disposeBag)
        searchController.searchBar.rx.searchButtonClicked.bind(to: viewModel.load).disposed(by: disposeBag)
        searchController.searchBar.rx.cancelButtonClicked.map { _ in nil }.bind(to: viewModel.query).disposed(by: disposeBag)
        searchController.searchBar.rx.cancelButtonClicked.bind(to: viewModel.load).disposed(by: disposeBag)

        refreshControl.rx.controlEvent(.valueChanged).bind(to: viewModel.load).disposed(by: disposeBag)

        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        collectionView.rx.willDisplayCell.subscribe(onNext: { cell, _ in
            cell.contentView.layer.cornerRadius = 4.0
            cell.contentView.layer.borderWidth = 1.0
            cell.contentView.layer.borderColor = UIColor.clear.cgColor
            cell.contentView.layer.masksToBounds = true

            cell.layer.shadowColor = UIColor.lightGray.cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
            cell.layer.shadowRadius = 2.0
            cell.layer.shadowOpacity = 1.0
            cell.layer.masksToBounds = false
            cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        }).disposed(by: disposeBag)

        viewModel.books.subscribe { [weak self] _ in self?.refreshControl.endRefreshing() }.disposed(by: disposeBag)
        viewModel.books.map { [AnimatableSectionModel<Int, Book>(model: 0, items: $0)] }.bind(to: collectionView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    }

    @objc private func popupFiltersView() {
        print("popupFiltersView")
    }

    // MARK: - Public methods

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
        let numberOfCellsPerRow: CGFloat = 2
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
