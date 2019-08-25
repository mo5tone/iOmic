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

class AppCoordinator: NSObject, WindowCoordinatorProtocol {
    // MARK: - CoordinatorProtocol

    let identifier = UUID()
    private(set) var coordinators: [CoordinatorProtocol] = []
    let window: UIWindow

    func start() {
        let mainCoordinator = MainCoordinator(window: window)
        coordinators.append(mainCoordinator)
        mainCoordinator.start()
    }

    // MARK: - Props.

    private let launchOptions: [UIApplication.LaunchOptionsKey: Any]

    // MARK: - Public

    init(window: UIWindow?, launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        guard let window = window else { fatalError("`window` can not be nil!") }
        self.window = window
        self.launchOptions = launchOptions ?? [:]
        super.init()
        IQKeyboardManager.shared.enable = true
    }
}

// MARK: - AppCoordinatorProtocol

extension AppCoordinator: AppCoordinatorProtocol {
    func showFlexExplorer() {
        #if DEBUG
            FLEXManager.shared()?.showExplorer()
        #endif
    }

    func hideFlexExplorer() {
        #if DEBUG
            FLEXManager.shared()?.hideExplorer()
        #endif
    }

    func willResignActive() {}
    func didEnterBackground() {}
    func willEnterForeground() {}
    func didBecomeActive() {}
    func willTerminate() {}
}
