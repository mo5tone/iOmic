//
//  AppCoordinator.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/8/24.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation
import IQKeyboardManagerSwift
import UIKit
#if DEBUG
    import FLEX
#endif

protocol AppCoordinatorProtocol {
    func showFlexExplorer()
    func hideFlexExplorer()
    func willResignActive()
    func didEnterBackground()
    func willEnterForeground()
    func didBecomeActive()
    func willTerminate()
}

class AppCoordinator: Coordinator {
    // MARK: - Static

    static let shared = AppCoordinator()

    // MARK: - Props.

    private var launchOptions: [UIApplication.LaunchOptionsKey: Any] = [:]

    // MARK: - Public

    func start(with launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        self.launchOptions = launchOptions ?? [:]
        let mainCoordinator: MainCoordinator = .init(window: window, delegate: self)
        append(coordinator: mainCoordinator)
        mainCoordinator.start()
        makeKeyAndVisible(mainCoordinator.tabBarController)
    }

    // MARK: - Private

    private init() {
        super.init(window: UIWindow(frame: UIScreen.main.bounds))
        setupConfigurations()
    }

    private func setupConfigurations() {
        IQKeyboardManager.shared.enable = true
    }
}

// MARK: - AppCoordinatorProtocol

extension AppCoordinator: AppCoordinatorProtocol {
    func showFlexExplorer() {
        #if DEBUG
            if FLEXManager.shared()?.isHidden ?? false {
                FLEXManager.shared()?.showExplorer()
            }
        #endif
    }

    func hideFlexExplorer() {
        #if DEBUG
            if !(FLEXManager.shared()?.isHidden ?? false) {
                FLEXManager.shared()?.hideExplorer()
            }
        #endif
    }

    func willResignActive() {}
    func didEnterBackground() {}
    func willEnterForeground() {}
    func didBecomeActive() {}
    func willTerminate() {}
}

// MARK: - MainCoordinatorDelegate

extension AppCoordinator: MainCoordinatorDelegate {}
