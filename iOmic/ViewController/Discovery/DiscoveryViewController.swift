//
//  DiscoveryViewController.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/8/24.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

protocol DiscoveryViewCoordinator: AnyObject {}

class DiscoveryViewController: UIViewController {
    // MARK: - props.

    @IBOutlet var collectionView: UICollectionView!
    private weak var coordinator: DiscoveryViewCoordinator?
    private var viewModel: DiscoveryViewModel
    private let disposeBag = DisposeBag()
    private lazy var refreshControl = UIRefreshControl()

    // MARK: - Private methods

    private func setupView() {
        collectionView.refreshControl = refreshControl
    }

    private func setupBinding() {
        viewModel.title.bind(to: navigationItem.rx.title).disposed(by: disposeBag)
        refreshControl.rx.controlEvent(.valueChanged).bind(to: viewModel.load).disposed(by: disposeBag)
//        viewModel.books.bind(to: collectionView.rx.items).disposed(by: disposeBag)
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
