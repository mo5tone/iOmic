//
//  MainCoordinator.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/8/24.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation
import UIKit

protocol MainCoordinatorDelegate: CoordinatorDelegate {}

class MainCoordinator: VisibleCoordinator {
    // MARK: - instace props.

    private weak var delegate: MainCoordinatorDelegate?

    // MARK: - Public instance methods

    init(window: UIWindow, delegate: MainCoordinatorDelegate?) {
        self.viewController = UITabBarController()
        super.init(window: window)
        self.delegate = delegate
    }

    func start() {
        guard let tabBarController = viewController as? UITabBarController else { return }
        let booksCoordinator: BooksCoordinator = .init(window: window, delegate: self)
        append(coordinator: booksCoordinator)
        booksCoordinator.navigationController.tabBarItem = .init(title: "Books", image: #imageLiteral(resourceName: "ic_books"), tag: 0)

        let discoveryCoordinator: DiscoveryCoordinator = .init(window: window, delegate: self)
        append(coordinator: discoveryCoordinator)
        discoveryCoordinator.navigationController.tabBarItem = .init(title: "Discovery", image: #imageLiteral(resourceName: "ic_discovery"), tag: 1)

        let downloadCoordinator: DownloadCoordinator = .init(window: window, delegate: self)
        append(coordinator: downloadCoordinator)
        downloadCoordinator.navigationController.tabBarItem = .init(title: "Download", image: #imageLiteral(resourceName: "ic_download"), tag: 2)

        let settingCoordinator: SettingCoordinator = .init(window: window, delegate: self)
        append(coordinator: settingCoordinator)
        settingCoordinator.navigationController.tabBarItem = .init(title: "Setting", image: #imageLiteral(resourceName: "ic_setting"), tag: 3)

        tabBarController.viewControllers = coordinators.compactMap { ($0 as? NavigationCoordinator)?.navigationController }

        makeKeyAndVisible(tabBarController)
    }
}

// MARK: - BooksCoordinatorDelegate

extension MainCoordinator: BooksCoordinatorDelegate {}

// MARK: - DiscoveryCoordinatorDelegate

extension MainCoordinator: DiscoveryCoordinatorDelegate {}

// MARK: - DownloadCoordinatorDelegate

extension MainCoordinator: DownloadCoordinatorDelegate {}

// MARK: - SettingCoordinatorDelegate

extension MainCoordinator: SettingCoordinatorDelegate {}
