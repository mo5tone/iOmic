//
//  SettingCoordinator.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/8/24.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation
import UIKit

protocol SettingCoordinatorDelegate: CoordinatorDelegate {}

class SettingCoordinator: Coordinator, NavigationCoordinatorProtocol {
    // MARK: - Props.

    private weak var delegate: SettingCoordinatorDelegate?
    private(set) var viewController: UIViewController = .init()
    private(set) var navigationController: UINavigationController = .init()

    // MARK: - Public

    init(window: UIWindow, delegate: SettingCoordinatorDelegate?) {
        super.init(window: window)
        self.delegate = delegate
        viewController = SettingViewController(coordinator: self, viewModel: .init())
        navigationController = UINavigationController(rootViewController: viewController)
    }
}

// MARK: - SettingViewCoordinator

extension SettingCoordinator: SettingViewCoordinator {}
