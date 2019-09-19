//
//  ChaptersDownloadCoordinator.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/9/18.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation
import UIKit

protocol ChaptersDownloadCoordinatorDelegate: CoordinatorDelegate {}

class ChaptersDownloadCoordinator: Coordinator, NavigationCoordinatorProtocol {
    private weak var delegate: ChaptersDownloadCoordinatorDelegate?
    private(set) var viewController: UIViewController = .init()
    private(set) var navigationController: UINavigationController = .init()

    init(window: UIWindow, delegate: ChaptersDownloadCoordinatorDelegate?, chapters: [Chapter]) {
        super.init(window: window)
        self.delegate = delegate
        viewController = ChaptersDownloadViewController(coordinator: self, viewModel: .init(chapters: chapters))
        navigationController = .init(rootViewController: viewController)
    }
}

// MARK: - ChaptersDownloadViewCoordinator

extension ChaptersDownloadCoordinator: ChaptersDownloadViewCoordinator {
    func beingDismissed() {
        delegate?.coordinatorDidEnd(self)
    }

    func dismiss(animated: Bool) {
        navigationController.popToRootViewController(animated: animated)
        navigationController.dismiss(animated: animated, completion: { [weak self] in self?.beingDismissed() })
    }
}
