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

protocol AppCoordinatorProtocol {
    func willResignActive()
    func didEnterBackground()
    func willEnterForeground()
    func didBecomeActive()
    func willTerminate()
}

class AppCoordinator: Coordinator {
    // MARK: - Static

    static let shared = AppCoordinator()

    // MARK: - Props.

    private var launchOptions: [UIApplication.LaunchOptionsKey: Any] = [:]

    // MARK: - Public

    func start(with launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        self.launchOptions = launchOptions ?? [:]
        let mainCoordinator: MainCoordinator = .init(window: window, delegate: self)
        append(coordinator: mainCoordinator)
        mainCoordinator.start()
    }

    // MARK: - Private

    private init() {
        super.init(window: UIWindow(frame: UIScreen.main.bounds))
        setupConfigurations()
    }

    private func setupConfigurations() {
        setupAppearance()
        IQKeyboardManager.shared.enable = true
        _ = DatabaseManager.shared.createTables().asObservable().takeUntil(rx.deallocated).subscribe(onError: { print($0) })
    }

    private func setupAppearance() {
        window.tintColor = UIColor.flat.tint

        let activityIndicatorViewAppearance = UIActivityIndicatorView.appearance()
        activityIndicatorViewAppearance.color = UIColor.flat.animation

        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.barTintColor = UIColor.flat.barTint
        navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.flat.darkText]
        navigationBarAppearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.flat.darkText]

        let labelAppearance = UILabel.appearance()
        labelAppearance.textColor = UIColor.flat.darkText

        let tableViewAppearance = UITableView.appearance()
        tableViewAppearance.backgroundColor = UIColor.flat.background
        tableViewAppearance.showsVerticalScrollIndicator = false
        tableViewAppearance.showsHorizontalScrollIndicator = false

        let collectionViewAppearance = UICollectionView.appearance()
        collectionViewAppearance.backgroundColor = UIColor.flat.background
        collectionViewAppearance.showsVerticalScrollIndicator = false
        collectionViewAppearance.showsHorizontalScrollIndicator = false
    }
}

// MARK: - AppCoordinatorProtocol

extension AppCoordinator: AppCoordinatorProtocol {
    func willResignActive() {}
    func didEnterBackground() {}
    func willEnterForeground() {}
    func didBecomeActive() {}
    func willTerminate() {}
}

// MARK: - MainCoordinatorDelegate

extension AppCoordinator: MainCoordinatorDelegate {}
