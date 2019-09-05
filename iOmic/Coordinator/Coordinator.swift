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

protocol CoordinatorDelegate: AnyObject {
    func coordinatorDidEnd(_ coordinator: Coordinator)
}

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
        guard !coordinators.contains(coordinator) else { return }
        if let view = coordinator as? ViewCoordinator {
            guard !viewControllers.contains(view.viewController) else { return }
            viewControllers.append(view.viewController)
        }
        coordinators.append(coordinator)
    }

    func remove(coordinator: Coordinator) {
        if let view = coordinator as? ViewCoordinator, let index = viewControllers.firstIndex(of: view.viewController) {
            viewControllers.remove(at: index)
        }
        if let index = coordinators.firstIndex(of: coordinator) {
            coordinators.remove(at: index)
        }
    }

    func makeKeyAndVisible(_ viewController: UIViewController) {
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }
}

// MARK: - CoordinatorDelegate

extension Coordinator: CoordinatorDelegate {
    func coordinatorDidEnd(_ coordinator: Coordinator) {
        remove(coordinator: coordinator)
    }
}

class TabBarCoordinator: Coordinator, UITabBarControllerDelegate {
    let tabBarController: UITabBarController

    override init(window: UIWindow) {
        tabBarController = .init()
        super.init(window: window)
        tabBarController.delegate = self
    }
}

class ViewCoordinator: Coordinator {
    var viewController: UIViewController!
}

class NavigationCoordinator: ViewCoordinator {
    var navigationController: UINavigationController!
}
