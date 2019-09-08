//
//  PagesViewController.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/9/7.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Kingfisher
import RxCocoa
import RxDataSources
import RxSwift
import UIKit

protocol PagesViewCoordinator: ViewCoordinatorDelegate {}

class PagesViewController: UIViewController {
    // MARK: - instance props.

    private let bag: DisposeBag = .init()
    private weak var coordinator: PagesViewCoordinator?
    private let viewModel: PagesViewModel
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var slider: UISlider!
    @IBOutlet var indexLabel: UILabel!
    private lazy var dataSource: RxCollectionViewSectionedAnimatedDataSource<AnimatableSectionModel<Int, Page>> = .init(configureCell: { [weak self] _, collectionView, indexPath, page in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PageCollectionViewCell.reusableIdentifier, for: indexPath)
        if let cell = cell as? PageCollectionViewCell {
            cell.delegate = self
            cell.setup(page)
        }
        return cell
    })

    // MARK: - public instance methods

    init(coordinator: PagesViewCoordinator?, viewModel: PagesViewModel) {
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

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParent { coordinator?.isMovingFromParentViewController() }
    }

    deinit { print(String(describing: self)) }

    // MARK: - private instance methods

    private func setupView() {
        view.backgroundColor = .black

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.navigationController?.setNavigationBarHidden(true, animated: true)
            UIView.animate(withDuration: 0.2, animations: { self?.slider.isHidden = true })
        }
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection = .horizontal
        collectionView.registerCell(PageCollectionViewCell.self)

        slider.minimumValue = 0
        slider.maximumValue = 0
        slider.value = 0

        indexLabel.textColor = .lightText
        indexLabel.font = .preferredFont(forTextStyle: .body)
    }

    private func setupBinding() {
        viewModel.chapter.map { $0.name }.bind(to: navigationItem.rx.title).disposed(by: bag)
        viewModel.pages.map { [AnimatableSectionModel<Int, Page>(model: 1, items: $0)] }.bind(to: collectionView.rx.items(dataSource: dataSource)).disposed(by: bag)
        viewModel.pages.filter { !$0.isEmpty }.map { $0.count }.subscribe(onNext: { [weak self] in self?.slider.maximumValue = Float($0 - 1) }).disposed(by: bag)
        collectionView.rx.setDelegate(self).disposed(by: bag)
        let contentOffsetChanged = collectionView.rx.contentOffset.compactMap { [weak self] offset -> Float? in
            guard let self = self else { return nil }
            return Float(offset.x / self.collectionView.frame.width)
        }.share()
        contentOffsetChanged.bind(to: slider.rx.value).disposed(by: bag)
        collectionView.rx.prefetchItems.withLatestFrom(viewModel.pages) { indexPaths, pages in indexPaths.compactMap { URL(string: pages[$0.item].imageURL ?? "") } }.subscribe(onNext: { ImagePrefetcher(urls: $0).start() }).disposed(by: bag)
        slider.rx.value.skipUntil(viewModel.pages.filter { !$0.isEmpty }).map { Int($0) }.distinctUntilChanged().map { IndexPath(item: $0, section: 0) }.subscribe(onNext: { [weak self] in self?.collectionView.scrollToItem(at: $0, at: .centeredHorizontally, animated: false) }).disposed(by: bag)
        Observable.merge(contentOffsetChanged, slider.rx.value.asObservable()).withLatestFrom(viewModel.pages) { "\(Int($0)) / \($1.count - 1)" }.bind(to: indexLabel.rx.text).disposed(by: bag)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PagesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        return collectionView.frame.size
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumInteritemSpacingForSectionAt _: Int) -> CGFloat {
        return 0
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        return 0
    }
}

// MARK: - PageCollectionViewCellDelegate

extension PagesViewController: PageCollectionViewCellDelegate {
    func pageCollectionViewCellOnTap(_: PageCollectionViewCell) {
        let isHidden = slider.isHidden
        navigationController?.setNavigationBarHidden(!isHidden, animated: true)
        UIView.animate(withDuration: 0.2, animations: { [weak self] in self?.slider.isHidden = !isHidden })
    }
}
