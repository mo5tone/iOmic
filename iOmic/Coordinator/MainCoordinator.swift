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
    // MARK: - Public instance methods

    func start() {
        let booksCoordinator: BooksCoordinator = .init(window: window)
        append(coordinator: booksCoordinator)
        booksCoordinator.navigationController.tabBarItem = .init(title: "Books", image: #imageLiteral(resourceName: "ic_books"), tag: 0)

        let discoveryCoordinator: DiscoveryCoordinator = .init(window: window)
        append(coordinator: discoveryCoordinator)
        discoveryCoordinator.navigationController.tabBarItem = .init(title: "Discovery", image: #imageLiteral(resourceName: "ic_discovery"), tag: 1)

        let downloadCoordinator: DownloadCoordinator = .init(window: window)
        append(coordinator: downloadCoordinator)
        downloadCoordinator.navigationController.tabBarItem = .init(title: "Download", image: #imageLiteral(resourceName: "ic_download"), tag: 2)

        let settingCoordinator: SettingCoordinator = .init(window: window)
        append(coordinator: settingCoordinator)
        settingCoordinator.navigationController.tabBarItem = .init(title: "Setting", image: #imageLiteral(resourceName: "ic_setting"), tag: 3)

        tabBarController.viewControllers = coordinators.compactMap { ($0 as? NavigationCoordinator)?.navigationController }
    }
}
