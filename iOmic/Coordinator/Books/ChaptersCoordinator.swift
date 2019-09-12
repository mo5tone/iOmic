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

class ChaptersCoordinator: Coordinator, VisibleCoordinatorProtocol {
    // MARK: - instace props.

    private weak var delegate: ChaptersCoordinatorDelegate?
    private(set) var viewController: UIViewController = .init()

    // MARK: - public methods

    init(window: UIWindow, delegate: ChaptersCoordinatorDelegate?, book: Book) {
        super.init(window: window)
        self.delegate = delegate
        viewController = ChaptersViewController(coordinator: self, viewModel: .init(book: book, persistence: Persistence.shared))
        viewController.hidesBottomBarWhenPushed = true
    }
}

// MARK: - ChaptersViewCoordinator

extension ChaptersCoordinator: ChaptersViewCoordinator {
    func showChapter(_ chapter: Chapter) {
        let coordinator: PagesCoordinator = .init(window: window, delegate: self, chapter: chapter)
        append(coordinator: coordinator)
        viewController.navigationController?.pushViewController(coordinator.viewController, animated: true)
    }

    func movingFromParent() {
        delegate?.coordinatorDidEnd(self)
    }
}

// MARK: - PagesCoordinatorDelegate

extension ChaptersCoordinator: PagesCoordinatorDelegate {}
