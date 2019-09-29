//
//  AppUtils.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/9/29.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation
import IQKeyboardManagerSwift
import RxSwift
import UIKit
import XCGLogger

// swiftlint:disable:next identifier_name
let Logger: XCGLogger = .default

class AppUtils {
    static let shared: AppUtils = .init()

    // MARK: - Instance props

    let window: UIWindow
    private let bag: DisposeBag

    // MARK: - Public instance methods

    func start(with launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Logger.debug(launchOptions)
        guard window == UIApplication.shared.delegate?.window else { return false }
        window.rootViewController = TabBarWireframe.create()
        window.makeKeyAndVisible()
        return true
    }

    func willResignActive() {
        Logger.debug()
    }

    func didEnterBackground() {
        Logger.debug()
    }

    func willEnterForeground() {
        Logger.debug()
    }

    func didBecomeActive() {
        Logger.debug()
    }

    func willTerminate() {
        Logger.debug()
    }

    // MARK: - Init

    private init() {
        window = .init(frame: UIScreen.main.bounds)
        bag = .init()
        setup()
    }

    // MARK: - Private instance methods

    private func setup() {
        // XCGLogger
        Logger.setup(level: .verbose, showLogIdentifier: false, showFunctionName: true, showThreadName: false, showLevel: false, showFileNames: true, showLineNumbers: true, showDate: false, writeToFile: nil, fileLevel: .error)
        // IQKeyboardManagerSwift
        IQKeyboardManager.shared.enable = true
        // DatabaseManager
        DatabaseManager.shared.createTables().subscribe(onCompleted: { Logger.info("Create tables done.") }, onError: { Logger.error($0) }).disposed(by: bag)
        // Appearance
        setupAppearance()
    }

    private func setupAppearance() {
        window.tintColor = UIColor.flat.tint

        let activityIndicatorViewAppearance = UIActivityIndicatorView.appearance()
        activityIndicatorViewAppearance.color = UIColor.flat.animation

        let switchAppearance = UISwitch.appearance()
        switchAppearance.onTintColor = UIColor.flat.onTint

        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.barTintColor = UIColor.flat.barTint
        navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.flat.darkText]
        navigationBarAppearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.flat.darkText]

        let toolbarAppearance = UIToolbar.appearance()
        toolbarAppearance.barTintColor = UIColor.flat.barTint

        let labelAppearance = UILabel.appearance()
        labelAppearance.textColor = UIColor.flat.darkText

        let textFieldAppearance = UITextField.appearance()
        textFieldAppearance.textColor = UIColor.flat.darkText

        let textViewAppearance = UITextView.appearance()
        textViewAppearance.textColor = UIColor.flat.darkText

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
