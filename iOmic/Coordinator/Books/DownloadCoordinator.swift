//
//  DownloadCoordinator.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/9/18.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation
import UIKit

protocol DownloadCoordinatorDelegate: CoordinatorDelegate {}

class DownloadCoordinator: Coordinator, NavigationCoordinatorProtocol {
    private weak var delegate: DownloadCoordinatorDelegate?
    private(set) var viewController: UIViewController = .init()
    private(set) var navigationController: UINavigationController = .init()

    init(window: UIWindow, delegate: DownloadCoordinatorDelegate?, chapters: [Chapter]) {
        super.init(window: window)
        self.delegate = delegate
        viewController = DownloadViewController(coordinator: self, viewModel: .init(chapters: chapters))
        navigationController = .init(rootViewController: viewController)
    }
}

// MARK: - DownloadViewCoordinator

extension DownloadCoordinator: DownloadViewCoordinator {
    func beingDismissed() {
        delegate?.coordinatorDidEnd(self)
    }

    func dismiss(animated: Bool) {
        navigationController.popToRootViewController(animated: animated)
        navigationController.dismiss(animated: animated, completion: { [weak self] in self?.beingDismissed() })
    }
}
