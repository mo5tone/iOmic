//
//  SettingCoordinator.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/8/24.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation
import UIKit

class SettingCoordinator: NSObject, ViewCoordinatorProtocol {
    // MARK: - ViewCoordinatorProtocol

    let identifier = UUID()
    private(set) var coordinators: [CoordinatorProtocol] = []
    var viewController: UIViewController { return navigationController }

    func start() {
        navigationController.pushViewController(SettingViewController(coordinator: self, viewModel: SettingViewModel()), animated: false)
    }

    // MARK: - Props.

    private let navigationController: UINavigationController

    // MARK: - Public

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
    }
}

extension SettingCoordinator: SettingViewCoordinator {}
