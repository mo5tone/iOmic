//
//  DownloadViewController.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/9/18.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import RxSwift
import UIKit

protocol DownloadViewCoordinator: PresentedViewCoordinator {
    func dismiss(animated: Bool)
}

class DownloadViewController: UIViewController {
    private weak var coordinator: DownloadViewCoordinator?
    private let viewModel: DownloadViewModel
    private let bag: DisposeBag = .init()
    private lazy var doneBarButtonItem: UIBarButtonItem = .init(barButtonSystemItem: .done, target: nil, action: nil)
    private lazy var allBarButtonItem: UIBarButtonItem = .init(title: "All", style: .done, target: nil, action: nil)
    private lazy var downloadBarButtonItem: UIBarButtonItem = .init(title: "Download", style: .done, target: nil, action: nil)
    @IBOutlet var collectionView: UICollectionView!

    init(coordinator: DownloadViewCoordinator?, viewModel: DownloadViewModel) {
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
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isToolbarHidden = true
    }

    private func setupView() {
        navigationItem.title = "Chapters to Download"
        navigationItem.rightBarButtonItem = doneBarButtonItem

        setToolbarItems([allBarButtonItem, .flexibleSpace, downloadBarButtonItem, .flexibleSpace], animated: true)

        collectionView.contentInset = .init(top: 8, left: 8, bottom: 8, right: 8)
        collectionView.allowsMultipleSelection = true
        collectionView.registerCell(ChapterCollectionViewCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    private func setupBinding() {
        viewModel.error.subscribe(onNext: { [weak self] in self?.coordinator?.whoops($0) }).disposed(by: bag)

        allBarButtonItem.rx.tap.subscribe { [weak self] _ in self?.markAllCells() }.disposed(by: bag)
        doneBarButtonItem.rx.tap.subscribe { [weak self] _ in self?.coordinator?.dismiss(animated: true) }.disposed(by: bag)
        downloadBarButtonItem.rx.tap.subscribe { [weak self] _ in self?.coordinator?.dismiss(animated: true) }.disposed(by: bag)
    }

    private func markAllCells() {
        let indexPaths = (0 ..< viewModel.chapters.count).map { IndexPath(item: $0, section: 0) }
        if collectionView.indexPathsForSelectedItems?.isEmpty ?? true {
            // TODO: - append all
            indexPaths.forEach { collectionView.selectItem(at: $0, animated: true, scrollPosition: []) }
        } else {
            // TODO: - remove all
            indexPaths.forEach { collectionView.deselectItem(at: $0, animated: true) }
        }
    }
}

// MARK: - UICollectionViewDataSource

extension DownloadViewController: UICollectionViewDataSource {
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

extension DownloadViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: - add chapter to download sequence
        print("didSelectItemAt \(indexPath)")
    }

    func collectionView(_: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        // TODO: - remove chapter from download sequence
        print("didDeselectItemAt \(indexPath)")
    }

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
