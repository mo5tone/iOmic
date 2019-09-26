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

protocol CoordinatorDelegate: AnyObject {
    func coordinatorDidEnd(_ coordinator: Coordinator)
}

extension CoordinatorDelegate where Self: Coordinator {
    func coordinatorDidEnd(_ coordinator: Coordinator) {
        remove(coordinator: coordinator)
    }
}

protocol VisibleCoordinatorProtocol {
    var viewController: UIViewController { get }
}

protocol NavigationCoordinatorProtocol: VisibleCoordinatorProtocol {
    var navigationController: UINavigationController { get }
}

protocol VisibleViewCoordinator: AnyObject {
    func whoops(_ error: Error)
}

protocol PresentedViewCoordinator: VisibleViewCoordinator {
    func beingDismissed()
}

protocol PushedViewCoordinator: VisibleViewCoordinator {
    func movingFromParent()
}

extension VisibleViewCoordinator where Self: VisibleCoordinatorProtocol {
    func whoops(_ error: Error) {
        let alert: UIAlertController = .init(title: "Whoops", message: error.localizedDescription, preferredStyle: .alert)
        viewController.present(alert, animated: true, completion: nil)
    }
}
