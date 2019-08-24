//
//  SettingViewController.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/8/24.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import UIKit
protocol SettingViewCoordinator: AnyObject {}

class SettingViewController: UIViewController {
    // MARK: - Props.

    weak var coordinator: SettingViewCoordinator?
    var viewModel: SettingViewModel?

    // MARK: - Public

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

// MARK: - Storyboarded

extension SettingViewController: Storyboarded {
    static var storyboardName: String { return "Setting" }
}
