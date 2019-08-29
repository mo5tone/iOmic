//
//  BooksViewController.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/8/24.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import UIKit

protocol BooksViewCoordinator: AnyObject {}

class BooksViewController: UIViewController {
    // MARK: - Props.

    private weak var coordinator: BooksViewCoordinator?
    private var viewModel: BooksViewModel

    // MARK: - Public

    init(coordinator: BooksViewCoordinator, viewModel: BooksViewModel) {
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
