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
    // MARK: - Props.

    private let window: UIWindow

    // MARK: - Public

    init(window: UIWindow) {
        self.window = window
        super.init()
    }

    override func start() {
        let iconSize = CGSize(width: 25, height: 25)
        let tabBarController = UITabBarController()

        let readingCoordinator = ReadingCoordinator()
        appendChildCoordinator(readingCoordinator)
        let readingViewController = ReadingViewController.instantiate()
        readingViewController.coordinator = readingCoordinator
        readingViewController.viewModel = ReadingViewModel()
        
        readingViewController.tabBarItem = UITabBarItem(title: "Reading", image: UIImage.fontAwesomeIcon(name: .bookReader, style: .solid, textColor: .tintColor, size: iconSize), tag: 0)

        let exploreCoordinator = ExploreCoordinator()
        appendChildCoordinator(exploreCoordinator)
        let exploreViewController = ExploreViewController.instantiate()
        exploreViewController.coordinator = exploreCoordinator
        exploreViewController.viewModel = ExploreViewModel()
        exploreViewController.tabBarItem = UITabBarItem(title: "Explore", image: UIImage.fontAwesomeIcon(name: .compass, style: .solid, textColor: .tintColor, size: iconSize), tag: 1)

        let downloadCoordinator = DownloadCoordinator()
        appendChildCoordinator(downloadCoordinator)
        let downloadViewController = DownloadViewController.instantiate()
        downloadViewController.coordinator = downloadCoordinator
        downloadViewController.viewModel = DownloadViewModel()
        downloadViewController.tabBarItem = UITabBarItem(title: "Download", image: UIImage.fontAwesomeIcon(name: .cloudDownloadAlt, style: .solid, textColor: .tintColor, size: iconSize), tag: 2)

        let settingCoordinator = SettingCoordinator()
        appendChildCoordinator(settingCoordinator)
        let settingViewController = SettingViewController.instantiate()
        settingViewController.coordinator = settingCoordinator
        settingViewController.viewModel = SettingViewModel()
        settingViewController.tabBarItem = UITabBarItem(title: "Setting", image: UIImage.fontAwesomeIcon(name: .cog, style: .solid, textColor: .tintColor, size: iconSize), tag: 3)

        tabBarController.viewControllers = [readingViewController, exploreViewController, downloadViewController, settingViewController]
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
}
