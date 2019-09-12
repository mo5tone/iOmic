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

protocol BaseViewCoordinator: AnyObject {
    func pushed(animated: Bool)
    
    func poped(animated: Bool)
    
    func presented(animated: Bool, completion: (() -> Void)?)
    
    func movingFromParent()
    
    func whoops(_ error: Error)
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

protocol VisibleCoordinatorProtocol {
    var viewController: UIViewController { get }
}

protocol NavigationCoordinatorProtocol: VisibleCoordinatorProtocol {
    var navigationController: UINavigationController { get }
}

extension CoordinatorDelegate where Self: Coordinator {
    func coordinatorDidEnd(_ coordinator: Coordinator) {
        remove(coordinator: coordinator)
    }
}

extension BaseViewCoordinator where Self: Coordinator {
    func pushed(animated: Bool = true) {
        guard let viewController = viewController else { return }
        navigationController?.pushViewController(viewController, animated: animated)
    }

    func poped(animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }

    func presented(animated: Bool = true, completion: (() -> Void)? = nil) {
        guard let viewController = viewController else { return }
        navigationController?.topViewController?.present(viewController, animated: animated, completion: completion)
    }

    func whoops(_ error: Error) {
        var attributes: EKAttributes = .topNote
        attributes.name = String(describing: ErrorViewController.self)
        attributes.entryBackground = .color(color: .init(UIColor.flat.error))
        SwiftEntryKit.display(entry: ErrorViewController(error: error), using: attributes)
    }
}
