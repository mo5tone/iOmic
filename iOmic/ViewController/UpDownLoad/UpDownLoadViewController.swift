//
//  UpDownLoadViewController.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/8/24.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

protocol UpDownLoadViewCoordinator: VisibleViewCoordinator {
    func presentUpload()
}

class UpDownLoadViewController: UIViewController {
    // MARK: - Props.

    private weak var coordinator: UpDownLoadViewCoordinator?
    private var viewModel: UpDownLoadViewModel
    private let bag: DisposeBag = .init()
    private lazy var addButtonItem: UIBarButtonItem = .init(barButtonSystemItem: .add, target: nil, action: nil)
    private lazy var segmentedControl: UISegmentedControl = .init(items: ["Upload", "Download"])

    // MARK: - public instance methods

    init(coordinator: UpDownLoadViewCoordinator, viewModel: UpDownLoadViewModel) {
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
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    // MARK: - private instance methods

    private func setupView() {
        navigationItem.leftBarButtonItem = addButtonItem
        navigationItem.titleView = segmentedControl

        segmentedControl.selectedSegmentIndex = 0
    }

    private func setupBinding() {
        addButtonItem.rx.tap
            .subscribe(onNext: { [weak self] in self?.coordinator?.presentUpload() })
            .disposed(by: bag)
        segmentedControl.rx.selectedSegmentIndex
            .subscribe(onNext: { [weak self] in self?.navigationItem.leftBarButtonItem = $0 == 0 ? self?.addButtonItem : nil })
            .disposed(by: bag)
    }
}
