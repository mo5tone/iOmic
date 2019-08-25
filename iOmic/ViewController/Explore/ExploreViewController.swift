//
//  ExploreViewController.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/8/24.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import UIKit

protocol ExploreViewCoordinator: AnyObject {}

class ExploreViewController: UIViewController {
    // MARK: - props.

    private weak var coordinator: ExploreViewCoordinator?
    private var viewModel: ExploreViewModel

    // MARK: - Public

    init(coordinator: ExploreViewCoordinator, viewModel: ExploreViewModel) {
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
