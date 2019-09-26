//
//  ChaptersDownloadViewController.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/9/18.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import RxSwift
import UIKit

protocol ChaptersDownloadViewCoordinator: PresentedViewCoordinator {
    func dismiss(animated: Bool)
}

class ChaptersDownloadViewController: UIViewController {
    private weak var coordinator: ChaptersDownloadViewCoordinator?
    private let viewModel: ChaptersDownloadViewModel
    private let bag: DisposeBag = .init()
    private lazy var doneBarButtonItem: UIBarButtonItem = .init(barButtonSystemItem: .done, target: nil, action: nil)
    private lazy var allBarButtonItem: UIBarButtonItem = .init(title: "All", style: .plain, target: nil, action: nil)
    private lazy var downloadBarButtonItem: UIBarButtonItem = .init(title: "Download", style: .done, target: nil, action: nil)
    @IBOutlet var collectionView: UICollectionView!

    init(coordinator: ChaptersDownloadViewCoordinator?, viewModel: ChaptersDownloadViewModel) {
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
        setToolbarItems([.flexibleSpace, downloadBarButtonItem, .flexibleSpace], animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isToolbarHidden = true
        setToolbarItems([], animated: true)
    }

    private func setupView() {
        navigationItem.leftBarButtonItem = allBarButtonItem
        navigationItem.title = "Chapters Download"
        navigationItem.rightBarButtonItem = doneBarButtonItem

        collectionView.contentInset = .init(top: 8, left: 8, bottom: 8, right: 8)
        collectionView.allowsMultipleSelection = true
        collectionView.registerCell(ChapterCollectionViewCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    private func setupBinding() {
        viewModel.error.subscribe(onNext: { [weak self] in self?.coordinator?.whoops($0) }).disposed(by: bag)

        allBarButtonItem.rx.tap.bind(to: viewModel.markAll).disposed(by: bag)
        allBarButtonItem.rx.tap.subscribe { [weak self] _ in self?.markAllCells() }.disposed(by: bag)
        doneBarButtonItem.rx.tap.subscribe { [weak self] _ in self?.coordinator?.dismiss(animated: true) }.disposed(by: bag)

        collectionView.rx.itemSelected.bind(to: viewModel.selectedIndexPath).disposed(by: bag)
        collectionView.rx.itemDeselected.bind(to: viewModel.deselectedIndexPath).disposed(by: bag)

        downloadBarButtonItem.rx.tap.subscribe { [weak self] _ in self?.coordinator?.dismiss(animated: true) }.disposed(by: bag)
    }

    private func markAllCells() {
        let indexPaths = (0 ..< viewModel.chapters.count).map { IndexPath(item: $0, section: 0) }
        if collectionView.indexPathsForSelectedItems?.isEmpty ?? true {
            indexPaths.forEach { collectionView.selectItem(at: $0, animated: true, scrollPosition: []) }
        } else {
            indexPaths.forEach { collectionView.deselectItem(at: $0, animated: true) }
        }
    }
}

// MARK: - UICollectionViewDataSource

extension ChaptersDownloadViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return viewModel.chapters.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChapterCollectionViewCell.reusableIdentifier, for: indexPath)
        if let cell = cell as? ChapterCollectionViewCell {
            cell.setup(viewModel.chapters[indexPath.item])
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ChaptersDownloadViewController: UICollectionViewDelegateFlowLayout {
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
}
