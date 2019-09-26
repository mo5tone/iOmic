//
//  FiltersViewController.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/8/31.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

protocol FiltersViewCoordinator: PresentedViewCoordinator {
    func dismiss()
    func applyFilters(_ filters: [FilterProrocol])
}

class FiltersViewController: UIViewController {
    // MARK: - instance props.

    private weak var coordinator: FiltersViewCoordinator?
    private let viewModel: FiltersViewModel
    private let bag: DisposeBag = .init()
    private lazy var cancelBarButtonItem: UIBarButtonItem = .init(barButtonSystemItem: .cancel, target: nil, action: nil)
    private lazy var doneBarButtonItem: UIBarButtonItem = .init(barButtonSystemItem: .done, target: nil, action: nil)
    @IBOutlet var collectionView: UICollectionView!

    // MARK: - private instance methods.

    private func setupView() {
        view.backgroundColor = UIColor.flat.background

        navigationItem.title = "Filters"
        navigationItem.leftBarButtonItem = cancelBarButtonItem
        navigationItem.rightBarButtonItem = doneBarButtonItem

        collectionView.contentInset = .init(top: 8, left: 8, bottom: 8, right: 8)
        collectionView.registerHeaderFooterView(FilterTitleCollectionHeader.self, supplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
        collectionView.registerCell(FilterCollectionViewCell.self)
        collectionView.allowsMultipleSelection = true
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    private func setupBinding() {
        doneBarButtonItem.rx.tap.subscribe(onNext: { [weak self] in self?.coordinator?.applyFilters(self?.viewModel.filters ?? []) }).disposed(by: bag)
        Observable.merge(cancelBarButtonItem.rx.tap.asObservable(), doneBarButtonItem.rx.tap.asObservable())
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in self?.coordinator?.dismiss() })
            .disposed(by: bag)
    }

    // MARK: - public instance methods.

    init(coordinator: FiltersViewCoordinator?, viewModel: FiltersViewModel) {
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
        viewModel.filters.compactMap { $0 as? PickFilter }.enumerated().forEach { offset, filter in
            if let filter = filter as? SinglePickFilter {
                let indexPath: IndexPath = .init(item: filter.state, section: offset)
                collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
            } else if let filter = filter as? MultiplePickFilter {
                let indexPaths: [IndexPath] = filter.state.map { .init(item: $0, section: offset) }
                indexPaths.forEach { collectionView.selectItem(at: $0, animated: true, scrollPosition: .centeredHorizontally) }
            }
        }
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension FiltersViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in _: UICollectionView) -> Int {
        return viewModel.filters.count
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let filter = viewModel.filters[section]
        if filter is ToggleFilter {
            return 1
        } else if let filter = filter as? PickFilter {
            return filter.options.count
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let identifier = FilterTitleCollectionHeader.reusableIdentifier
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath)
        if let view = view as? FilterTitleCollectionHeader {
            view.titleLabel.text = viewModel.filters[indexPath.section].title
        }
        return view
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = FilterCollectionViewCell.reusableIdentifier
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        if let cell = cell as? FilterCollectionViewCell, let filter = viewModel.filters[indexPath.section] as? PickFilter {
            cell.nameLabel.text = filter.options[indexPath.item].name
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, referenceSizeForHeaderInSection _: Int) -> CGSize {
        let height = UIFont.preferredFont(forTextStyle: .body).textSize().height
        return .init(width: collectionView.frame.width, height: height + 16)
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let filter = viewModel.filters[indexPath.section] as? PickFilter {
            let size = UIFont.preferredFont(forTextStyle: .body).textSize(with: filter.options[indexPath.item].name)
            return .init(width: size.width + 16, height: size.height + 16)
        }
        return .zero
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        return 8
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumInteritemSpacingForSectionAt _: Int) -> CGFloat {
        return 8
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let filter = viewModel.filters[indexPath.section] as? SinglePickFilter {
            filter.state = indexPath.item
            let selectedItems = collectionView.indexPathsForSelectedItems?.filter { $0.section == indexPath.section } ?? []
            selectedItems.filter { $0.item != indexPath.item }.forEach { collectionView.deselectItem(at: $0, animated: true) }
        } else if let filter = viewModel.filters[indexPath.section] as? MultiplePickFilter {
            filter.state.append(indexPath.item)
        }
    }

    func collectionView(_: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let filter = viewModel.filters[indexPath.section] as? MultiplePickFilter {
            filter.state.removeAll(where: { $0 == indexPath.item })
        }
    }
}
