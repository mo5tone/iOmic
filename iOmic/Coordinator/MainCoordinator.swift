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

class MainCoordinator: Coordinator, VisibleCoordinatorProtocol {
    // MARK: - instace props.

    private weak var delegate: MainCoordinatorDelegate?
    private(set) var viewController: UIViewController = .init()

    // MARK: - Public instance methods

    init(window: UIWindow, delegate: MainCoordinatorDelegate?) {
        super.init(window: window)
        viewController = UITabBarController()
        self.delegate = delegate
    }

    func start() {
        guard let tabBarController = viewController as? UITabBarController else { return }
        let booksCoordinator: BooksCoordinator = .init(window: window, delegate: self)
        append(coordinator: booksCoordinator)
        booksCoordinator.navigationController.tabBarItem = .init(title: "Books", image: #imageLiteral(resourceName: "ic_tabbar_books"), tag: 0)

        let discoveryCoordinator: DiscoveryCoordinator = .init(window: window, delegate: self)
        append(coordinator: discoveryCoordinator)
        discoveryCoordinator.navigationController.tabBarItem = .init(title: "Discovery", image: #imageLiteral(resourceName: "ic_tabbar_discovery"), tag: 1)

        let downloadCoordinator: UpDownLoadCoordinator = .init(window: window, delegate: self)
        append(coordinator: downloadCoordinator)
        downloadCoordinator.navigationController.tabBarItem = .init(title: "Download", image: #imageLiteral(resourceName: "ic_tabbar_updown_load"), tag: 2)

        let settingCoordinator: SettingCoordinator = .init(window: window, delegate: self)
        append(coordinator: settingCoordinator)
        settingCoordinator.navigationController.tabBarItem = .init(title: "Setting", image: #imageLiteral(resourceName: "ic_tabbar_setting"), tag: 3)

        tabBarController.viewControllers = coordinators.compactMap { ($0 as? NavigationCoordinatorProtocol)?.navigationController }

        makeKeyAndVisible(tabBarController)
    }
}

// MARK: - BooksCoordinatorDelegate

extension MainCoordinator: BooksCoordinatorDelegate {}

// MARK: - DiscoveryCoordinatorDelegate

extension MainCoordinator: DiscoveryCoordinatorDelegate {}

// MARK: - UpDownLoadCoordinatorDelegate

extension MainCoordinator: UpDownLoadCoordinatorDelegate {}

// MARK: - SettingCoordinatorDelegate

extension MainCoordinator: SettingCoordinatorDelegate {}
