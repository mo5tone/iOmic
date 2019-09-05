//
//  BooksCoordinator.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/8/24.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation
import UIKit

protocol BooksCoordinatorDelegate: CoordinatorDelegate {}

class BooksCoordinator: NavigationCoordinator {
    // MARK: - Props.

    private weak var delegate: BooksCoordinatorDelegate?

    // MARK: - Public

    init(window: UIWindow, delegate: BooksCoordinatorDelegate?) {
        super.init(window: window)
        self.delegate = delegate
        viewController = BooksViewController(coordinator: self, viewModel: .init())
        navigationController = .init(rootViewController: viewController)
        navigationController.navigationBar.prefersLargeTitles = true
    }
}

// MARK: - BooksViewCoordinator

extension BooksCoordinator: BooksViewCoordinator {}
