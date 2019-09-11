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

    // MARK: - public methods

    init(window: UIWindow, delegate: ChaptersCoordinatorDelegate?, navigationController: UINavigationController?, book: Book) {
        super.init(window: window)
        self.delegate = delegate
        self.navigationController = navigationController
        viewController = ChaptersViewController(coordinator: self, viewModel: .init(book: book, persistence: Persistence.shared))
        viewController.hidesBottomBarWhenPushed = true
    }

    func start() {
        pushed()
        navigationController?.navigationBar.prefersLargeTitles = false
    }
}

// MARK: - ChaptersViewCoordinator

extension ChaptersCoordinator: ChaptersViewCoordinator {
    func showChapter(_ chapter: Chapter) {
        let coordinator: PagesCoordinator = .init(window: window, delegate: self, navigationController: navigationController, chapter: chapter)
        append(coordinator: coordinator)
        coordinator.start()
    }

    func movingFromParent() {
        delegate?.coordinatorDidEnd(self)
    }
}

// MARK: - PagesCoordinatorDelegate

extension ChaptersCoordinator: PagesCoordinatorDelegate {}
