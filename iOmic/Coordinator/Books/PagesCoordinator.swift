//
//  PagesCoordinator.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/9/7.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

protocol PagesCoordinatorDelegate: CoordinatorDelegate {}

class PagesCoordinator: ViewCoordinator {
    // MARK: - instance props.

    private weak var delegate: PagesCoordinatorDelegate?

    // MARK: - public instance methods

    init(window: UIWindow, delegate: PagesCoordinatorDelegate?, navigationController: UINavigationController?, chapter: Chapter) {
        super.init(window: window)
        self.delegate = delegate
        self.navigationController = navigationController
        viewController = PagesViewController(coordinator: self, viewModel: .init(chapter: chapter))
        viewController.hidesBottomBarWhenPushed = true
    }

    func start() {
        pushed()
        navigationController?.navigationBar.prefersLargeTitles = false
    }
}

// MARK: - PagesViewCoordinator

extension PagesCoordinator: PagesViewCoordinator {
    func movingFromParent() {
        delegate?.coordinatorDidEnd(self)
    }
}
