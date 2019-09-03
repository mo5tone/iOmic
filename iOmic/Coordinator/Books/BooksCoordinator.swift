//
//  BooksCoordinator.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/8/24.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation
import UIKit

class BooksCoordinator: NavigationCoordinator {
    // MARK: - Props.

    // MARK: - Public

    override init(window: UIWindow) {
        super.init(window: window)
        let rootViewController = BooksViewController(coordinator: self, viewModel: .init())
        self.rootViewController = rootViewController
        navigationController = .init(rootViewController: rootViewController)
        navigationController.navigationBar.prefersLargeTitles = true
    }
}

// MARK: - BooksViewCoordinator

extension BooksCoordinator: BooksViewCoordinator {}
