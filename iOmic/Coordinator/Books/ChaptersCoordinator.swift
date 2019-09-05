//
//  ChaptersCoordinator.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/9/5.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation
import UIKit

protocol ChaptersCoordinatorDelegate: CoordinatorDelegate {}

class ChaptersCoordinator: ViewCoordinator {
    // MARK: - instace props.

    private weak var delegate: ChaptersCoordinatorDelegate?
    private weak var navigationController: UINavigationController?

    // MARK: - public methods

    init(window: UIWindow, delegate: ChaptersCoordinatorDelegate?, navigationController _: UINavigationController?, book: Book) {
        super.init(window: window)
        self.delegate = delegate
        viewController = ChaptersViewController(coordinator: self, viewModel: .init(book: book))
    }
}

// MARK: - ChaptersViewCoordinator

extension ChaptersCoordinator: ChaptersViewCoordinator {}
