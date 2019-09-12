//
//  Coordinator.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/8/24.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation
import RxSwift
import SwiftEntryKit
import UIKit

protocol CoordinatorDelegate: AnyObject {
    func coordinatorDidEnd(_ coordinator: Coordinator)
}

class Coordinator: NSObject {
    // MARK: - instance props.

    let window: UIWindow
    private(set) var coordinators: [Coordinator] = []

    // MARK: - Public instance methods

    init(window: UIWindow) {
        self.window = window
        super.init()
    }

    func append(coordinator: Coordinator) {
        guard !coordinators.contains(coordinator) else { return }
        coordinators.append(coordinator)
    }

    func remove(coordinator: Coordinator) {
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

class NavigationCoordinator: Coordinator {
    var viewController: UIViewController!
    var navigationController: UINavigationController!
}

protocol BaseViewCoordinator: AnyObject {
    func pushed(animated: Bool)

    func poped(animated: Bool)

    func presented(animated: Bool, completion: (() -> Void)?)

    func movingFromParent()

    func whoops(_ error: Error)
}

class ViewCoordinator: Coordinator {
    var viewController: UIViewController!
    weak var navigationController: UINavigationController?
}

extension BaseViewCoordinator where Self: ViewCoordinator {
    func pushed(animated: Bool = true) {
        navigationController?.pushViewController(viewController, animated: animated)
    }

    func poped(animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }

    func presented(animated: Bool = true, completion: (() -> Void)? = nil) {
        navigationController?.topViewController?.present(viewController, animated: animated, completion: completion)
    }

    func whoops(_: Error) {
        var attributes: EKAttributes = .topToast
        attributes.name = String(describing: FiltersViewController.self)
//        SwiftEntryKit.display(entry: <#T##UIViewController#>, using: <#T##EKAttributes#>)
    }
}
