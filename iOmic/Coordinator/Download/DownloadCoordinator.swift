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

class DownloadCoordinator: Coordinator, NavigationCoordinatorProtocol {
    // MARK: - Props.

    private weak var delegate: DownloadCoordinatorDelegate?
    private(set) var viewController: UIViewController = .init()
    private(set) var navigationController: UINavigationController = .init()

    // MARK: - Public

    init(window: UIWindow, delegate: DownloadCoordinatorDelegate?) {
        super.init(window: window)
        self.delegate = delegate
        viewController = DownloadViewController(coordinator: self, viewModel: .init())
        navigationController = .init(rootViewController: viewController)
    }
}

// MARK: - DownloadViewCoordinator

extension DownloadCoordinator: DownloadViewCoordinator {}
