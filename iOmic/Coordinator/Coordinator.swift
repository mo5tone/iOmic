//
//  Coordinator.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/8/24.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

class Coordinator: NSObject {
    // MARK: - instance props.

    let window: UIWindow
    private(set) var coordinators: [Coordinator] = []
    private(set) var viewControllers: [UIViewController] = []

    // MARK: - Public instance methods

    init(window: UIWindow) {
        self.window = window
        super.init()
    }

    func append(coordinator: Coordinator) {
        coordinators.append(coordinator)
        if let view = coordinator as? ViewCoordinator {
            viewControllers.append(view.viewController)
        }
    }

    func remove(coordinator: Coordinator) {
        while let index = coordinators.firstIndex(of: coordinator) {
            coordinators.remove(at: index)
        }
    }

    func makeKeyAndVisible(_ viewController: UIViewController) {
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }
}

class TabBarCoordinator: Coordinator {
    let tabBarController: UITabBarController

    init(window: UIWindow, tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
        super.init(window: window)
        self.tabBarController.delegate = self
    }
}

// MARK: - UITabBarControllerDelegate

extension TabBarCoordinator: UITabBarControllerDelegate {}

class ViewCoordinator: Coordinator {
    var viewController: UIViewController!
}

class NavigationCoordinator: ViewCoordinator {
    var navigationController: UINavigationController!
}
