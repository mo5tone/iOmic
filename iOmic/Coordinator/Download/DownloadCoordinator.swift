//
//  DownloadCoordinator.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/8/24.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation
import UIKit

protocol DownloadCoordinatorDelegate: CoordinatorDelegate {}

class DownloadCoordinator: NavigationCoordinator {
    // MARK: - Props.

    private weak var delegate: DownloadCoordinatorDelegate?

    // MARK: - Public

    init(window: UIWindow, delegate: DownloadCoordinatorDelegate?) {
        super.init(window: window)
        self.delegate = delegate
        viewController = DownloadViewController(coordinator: self, viewModel: .init())
        navigationController = .init(rootViewController: viewController)
        navigationController.navigationBar.prefersLargeTitles = true
    }
}

// MARK: - DownloadViewCoordinator

extension DownloadCoordinator: DownloadViewCoordinator {}
