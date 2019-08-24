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

class AppCoordinator: Coordinator {
    // MARK: - Props.

    private let window: UIWindow
    private let launchOptions: [UIApplication.LaunchOptionsKey: Any]

    // MARK: - Public

    init(window: UIWindow?, launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        guard let window = window else { fatalError("`window` can not be nil!") }
        self.window = window
        self.launchOptions = launchOptions ?? [:]
        super.init()
        IQKeyboardManager.shared.enable = true
    }

    func willResignActive() {}
    func didEnterBackground() {}
    func willEnterForeground() {}
    func didBecomeActive() {}
    func willTerminate() {}

    override func start() {
        let mainCoordinator = MainCoordinator(window: window)
        appendChildCoordinator(mainCoordinator)
        mainCoordinator.start()
    }
}
