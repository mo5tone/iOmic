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

class MainCoordinator: NSObject, WindowCoordinatorProtocol {
    // MARK: - CoordinatorProtocol

    let identifier = UUID()
    let window: UIWindow
    private(set) var coordinators: [CoordinatorProtocol] = []

    func start() {
        let iconSize = CGSize(width: 25, height: 25)
        let tabBarController = UITabBarController()

        let readingCoordinator = ReadingCoordinator(navigationController: UINavigationController())
        readingCoordinator.start()
        coordinators.append(readingCoordinator)
        readingCoordinator.viewController.tabBarItem = UITabBarItem(title: "Reading", image: UIImage.fontAwesomeIcon(name: .bookReader, style: .solid, textColor: .tintColor, size: iconSize), tag: 0)

        let exploreCoordinator = ExploreCoordinator(navigationController: UINavigationController())
        exploreCoordinator.start()
        coordinators.append(exploreCoordinator)
        exploreCoordinator.viewController.tabBarItem = UITabBarItem(title: "Exploring", image: UIImage.fontAwesomeIcon(name: .compass, style: .solid, textColor: .tintColor, size: iconSize), tag: 1)

        let downloadCoordinator = DownloadCoordinator(navigationController: UINavigationController())
        downloadCoordinator.start()
        coordinators.append(downloadCoordinator)
        downloadCoordinator.viewController.tabBarItem = UITabBarItem(title: "Downloading", image: UIImage.fontAwesomeIcon(name: .cloudDownloadAlt, style: .solid, textColor: .tintColor, size: iconSize), tag: 2)

        let settingCoordinator = SettingCoordinator(navigationController: UINavigationController())
        settingCoordinator.start()
        coordinators.append(settingCoordinator)
        settingCoordinator.viewController.tabBarItem = UITabBarItem(title: "Setting", image: UIImage.fontAwesomeIcon(name: .cog, style: .solid, textColor: .tintColor, size: iconSize), tag: 3)

        tabBarController.viewControllers = coordinators.compactMap { $0 as? ViewCoordinatorProtocol }.compactMap { $0.viewController }
        tabBarController.delegate = self

        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }

    // MARK: - Props.

    // MARK: - Public

    init(window: UIWindow) {
        self.window = window
        super.init()
    }
}

// MARK: - UITabBarControllerDelegate

extension MainCoordinator: UITabBarControllerDelegate {}
