//
//  ReadingViewController.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/8/24.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import UIKit

protocol ReadingViewCoordinator: AnyObject {}

class ReadingViewController: UIViewController {
    // MARK: - Props.

    private weak var coordinator: ReadingViewCoordinator?
    private var viewModel: ReadingViewModel

    // MARK: - Public

    init(coordinator: ReadingViewCoordinator, viewModel: ReadingViewModel) {
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
    }
}
