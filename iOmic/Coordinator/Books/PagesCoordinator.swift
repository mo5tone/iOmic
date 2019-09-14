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

class PagesCoordinator: Coordinator, VisibleCoordinatorProtocol {
    // MARK: - instance props.

    private weak var delegate: PagesCoordinatorDelegate?
    private(set) var viewController: UIViewController = .init()

    // MARK: - public instance methods

    init(window: UIWindow, delegate: PagesCoordinatorDelegate?, chapter: Chapter) {
        super.init(window: window)
        self.delegate = delegate
        viewController = PagesViewController(coordinator: self, viewModel: .init(chapter: chapter, persistence: Persistence.shared))
        viewController.hidesBottomBarWhenPushed = true
    }
}

// MARK: - PagesViewCoordinator

extension PagesCoordinator: PagesViewCoordinator {
    func movingFromParent() {
        delegate?.coordinatorDidEnd(self)
    }
}
