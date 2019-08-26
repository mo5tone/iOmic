//
//  MainCoordinator.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/8/24.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import FontAwesome
import Foundation
import UIKit

class MainCoordinator: Coordinator {
    // MARK: - Public

    func start() {
        let iconSize = CGSize(width: 25, height: 25)
        let tabBarController = UITabBarController()

        let readingCoordinator = ReadingCoordinator(window: window)
        readingCoordinator.start()
        coordinators.append(readingCoordinator)
        readingCoordinator.viewController?.tabBarItem = UITabBarItem(title: "Reading", image: UIImage.fontAwesomeIcon(name: .bookReader, style: .solid, textColor: .tintColor, size: iconSize), tag: 0)

        let exploreCoordinator = ExploreCoordinator(window: window)
        exploreCoordinator.start()
        coordinators.append(exploreCoordinator)
        exploreCoordinator.viewController?.tabBarItem = UITabBarItem(title: "Exploring", image: UIImage.fontAwesomeIcon(name: .compass, style: .solid, textColor: .tintColor, size: iconSize), tag: 1)

        let downloadCoordinator = DownloadCoordinator(window: window)
        downloadCoordinator.start()
        coordinators.append(downloadCoordinator)
        downloadCoordinator.viewController?.tabBarItem = UITabBarItem(title: "Downloading", image: UIImage.fontAwesomeIcon(name: .cloudDownloadAlt, style: .solid, textColor: .tintColor, size: iconSize), tag: 2)

        let settingCoordinator = SettingCoordinator(window: window)
        settingCoordinator.start()
        coordinators.append(settingCoordinator)
        settingCoordinator.viewController?.tabBarItem = UITabBarItem(title: "Setting", image: UIImage.fontAwesomeIcon(name: .cog, style: .solid, textColor: .tintColor, size: iconSize), tag: 3)

        tabBarController.viewControllers = coordinators.compactMap { $0.viewController }
        tabBarController.delegate = self

        viewController = tabBarController
        makeKeyAndVisible()
    }
}

// MARK: - UITabBarControllerDelegate

extension MainCoordinator: UITabBarControllerDelegate {}
