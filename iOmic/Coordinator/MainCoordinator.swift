//
//  MainCoordinator.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/8/24.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation
import UIKit

class MainCoordinator: Coordinator {
    // MARK: - Public

    func start() {
        let tabBarController = UITabBarController()

        let booksCoordinator = BooksCoordinator(window: window)
        booksCoordinator.start()
        coordinators.append(booksCoordinator)
        booksCoordinator.viewController?.tabBarItem = UITabBarItem(title: "Books", image: #imageLiteral(resourceName: "ic_books"), tag: 0)

        let discoveryCoordinator = DiscoveryCoordinator(window: window)
        discoveryCoordinator.start()
        coordinators.append(discoveryCoordinator)
        discoveryCoordinator.viewController?.tabBarItem = UITabBarItem(title: "Discovery", image: #imageLiteral(resourceName: "ic_discovery"), tag: 1)

        let downloadCoordinator = DownloadCoordinator(window: window)
        downloadCoordinator.start()
        coordinators.append(downloadCoordinator)
        downloadCoordinator.viewController?.tabBarItem = UITabBarItem(title: "Download", image: #imageLiteral(resourceName: "ic_download"), tag: 2)

        let settingCoordinator = SettingCoordinator(window: window)
        settingCoordinator.start()
        coordinators.append(settingCoordinator)
        settingCoordinator.viewController?.tabBarItem = UITabBarItem(title: "Setting", image: #imageLiteral(resourceName: "ic_setting"), tag: 3)

        tabBarController.viewControllers = coordinators.compactMap { $0.viewController }
        tabBarController.delegate = self

        viewController = tabBarController
        makeKeyAndVisible()
    }
}

// MARK: - UITabBarControllerDelegate

extension MainCoordinator: UITabBarControllerDelegate {}
