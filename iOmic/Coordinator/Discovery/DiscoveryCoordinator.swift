//
//  DiscoveryCoordinator.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/8/24.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation
import UIKit

class DiscoveryCoordinator: Coordinator {
    // MARK: - Props.

    // MARK: - Public

    override init(window: UIWindow) {
        super.init(window: window)
        viewController = UINavigationController()
    }

    func start() {
        guard let navigationController = viewController as? UINavigationController else { return }
        navigationController.pushViewController(DiscoveryViewController(coordinator: self, viewModel: DiscoveryViewModel(sourceProtocol: ManHuaRen.shared)), animated: false)
    }
}

extension DiscoveryCoordinator: DiscoveryViewCoordinator {}
