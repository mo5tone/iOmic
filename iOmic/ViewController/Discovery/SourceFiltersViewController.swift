//
//  SourceFiltersViewController.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/8/31.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import RxCocoa
import RxSwift
import SwiftEntryKit
import UIKit

protocol SourceFiltersViewCoordinator: AnyObject {}

class SourceFiltersViewController: UIViewController {
    // MARK: - instance props.

    private weak var coordinator: SourceFiltersViewCoordinator?
    private let viewModel: SourceFiltersViewModel
    private let bag: DisposeBag = .init()
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var okButton: UIButton!
    @IBOutlet var collectionView: UICollectionView!

    // MARK: - private instance methods.

    private func setupView() {
        view.backgroundColor = .clear

        cancelButton.setTitle("Cancel", for: .normal)
        okButton.setTitle("OK", for: .normal)

        collectionView.backgroundColor = .groupTableViewBackground
        collectionView.registerCell(SinglePickFilterCollectionViewCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    private func setupBinding() {
        Observable.merge(cancelButton.rx.tap.asObservable(), okButton.rx.tap.asObservable())
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: { SwiftEntryKit.dismiss(.specific(entryName: String(describing: SourceFiltersViewController.self)), with: nil) })
            .disposed(by: bag)
    }

    // MARK: - public instance methods.

    init(coordinator: SourceFiltersViewCoordinator?, viewModel: SourceFiltersViewModel) {
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

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension SourceFiltersViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = SinglePickFilterCollectionViewCell.reusableIdentifier
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        if let cell = cell as? SinglePickFilterCollectionViewCell, let filter = viewModel.filters[indexPath.section] as? PickFilter {
            cell.nameLabel.text = filter.options[indexPath.item].name
            if let filter = filter as? SinglePickFilter {
                cell.isSelected = filter.state == indexPath.item
            } else if let filter = filter as? MultiplePickFilter {
                cell.isSelected = filter.state.contains(indexPath.item)
            }
        }
        return cell
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let filter = viewModel.filters[indexPath.section] as? PickFilter {
            let label: UILabel = .init(frame: .init(origin: .zero, size: .init(width: Double.infinity, height: Double.infinity)))
            label.font = .preferredFont(forTextStyle: .body)
            label.text = filter.options[indexPath.item].name
            let size = label.intrinsicContentSize
            return .init(width: size.width + 16, height: size.height + 16)
        }
        return .zero
    }
}
