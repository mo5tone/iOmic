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
    // MARK: - Props.

    let window: UIWindow

    var coordinators: [Coordinator] = []

    // MARK: - Public

    init(window: UIWindow) {
        self.window = window
        super.init()
    }

    func makeKeyAndVisible(_ viewController: UIViewController) {
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }
}

class NavigationCoordinator: Coordinator {
    var navigationController: UINavigationController
    var rootViewController: UIViewController?

    override init(window: UIWindow) {
        navigationController = .init()
        super.init(window: window)
    }
}

class TabBarCoordinator: Coordinator {
    let tabBarController: UITabBarController

    init(window: UIWindow, tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
        super.init(window: window)
    }
}

class ViewCoordinator: Coordinator {
    var viewController: UIViewController?
}
