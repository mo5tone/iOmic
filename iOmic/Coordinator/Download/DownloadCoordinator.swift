//
//  DownloadCoordinator.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/8/24.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation
import UIKit

class DownloadCoordinator: NavigationCoordinator {
    // MARK: - Props.

    // MARK: - Public

    override init(window: UIWindow) {
        super.init(window: window)
        let rootViewController = DownloadViewController(coordinator: self, viewModel: DownloadViewModel())
        self.rootViewController = rootViewController
        navigationController = .init(rootViewController: rootViewController)
        navigationController.navigationBar.prefersLargeTitles = true
    }
}

extension DownloadCoordinator: DownloadViewCoordinator {}
