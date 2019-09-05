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

protocol CoordinatorFlowDelegate: AnyObject {
    func coordinatorDidFinish(_ coordinator: Coordinator)
}

class Coordinator: NSObject {
    // MARK: - instance props.

    let window: UIWindow
    private(set) weak var flowDelegate: CoordinatorFlowDelegate?
    private(set) var coordinators: [Coordinator] = []
    private(set) var viewControllers: [UIViewController] = []

    // MARK: - Public instance methods

    init(window: UIWindow, flowDelegate: CoordinatorFlowDelegate? = nil) {
        self.window = window
        self.flowDelegate = flowDelegate
        super.init()
    }

    func append(coordinator: Coordinator) {
        coordinators.append(coordinator)
        if let view = coordinator as? ViewCoordinator {
            viewControllers.append(view.viewController)
        }
    }

    func remove(coordinator: Coordinator) {
        if let view = coordinator as? ViewCoordinator {
            while let index = viewControllers.firstIndex(of: view.viewController) {
                viewControllers.remove(at: index)
            }
        }
        while let index = coordinators.firstIndex(of: coordinator) {
            coordinators.remove(at: index)
        }
    }

    func makeKeyAndVisible(_ viewController: UIViewController) {
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }
}

// MARK: - CoordinatorFlowDelegate

extension Coordinator: CoordinatorFlowDelegate {
    func coordinatorDidFinish(_ coordinator: Coordinator) {
        remove(coordinator: coordinator)
    }
}

class TabBarCoordinator: Coordinator {
    let tabBarController: UITabBarController

    override init(window: UIWindow, flowDelegate: CoordinatorFlowDelegate? = nil) {
        tabBarController = .init()
        super.init(window: window, flowDelegate: flowDelegate)
        tabBarController.delegate = self
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
