//
//  TabBarViewController.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/9/29.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController, TabBarViewProtocol {
    var presenter: TabBarViewOutputProtocol!

    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    // MARK: - Private instance methods

    private func setup() {
        viewControllers = [BooksWireframe.create(), DiscoveryWireframe.create(), FilesWireframe.create(), SettingsWireframe.create()]
    }
}
