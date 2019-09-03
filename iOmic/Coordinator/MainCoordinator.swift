//
//  MainCoordinator.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/8/24.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation
import UIKit

class MainCoordinator: TabBarCoordinator {
    // MARK: - Public

    func start() {
        let booksCoordinator = BooksCoordinator(window: window)
        coordinators.append(booksCoordinator)
        booksCoordinator.navigationController.tabBarItem = UITabBarItem(title: "Books", image: #imageLiteral(resourceName: "ic_books"), tag: 0)

        let discoveryCoordinator = DiscoveryCoordinator(window: window)
        coordinators.append(discoveryCoordinator)
        discoveryCoordinator.navigationController.tabBarItem = UITabBarItem(title: "Discovery", image: #imageLiteral(resourceName: "ic_discovery"), tag: 1)

        let downloadCoordinator = DownloadCoordinator(window: window)
        coordinators.append(downloadCoordinator)
        downloadCoordinator.navigationController.tabBarItem = UITabBarItem(title: "Download", image: #imageLiteral(resourceName: "ic_download"), tag: 2)

        let settingCoordinator = SettingCoordinator(window: window)
        coordinators.append(settingCoordinator)
        settingCoordinator.navigationController.tabBarItem = UITabBarItem(title: "Setting", image: #imageLiteral(resourceName: "ic_setting"), tag: 3)

        tabBarController.viewControllers = coordinators.compactMap { ($0 as? NavigationCoordinator)?.navigationController }
        tabBarController.delegate = self

        makeKeyAndVisible(tabBarController)
    }
}

// MARK: - UITabBarControllerDelegate

extension MainCoordinator: UITabBarControllerDelegate {}
