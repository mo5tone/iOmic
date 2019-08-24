//
//  DownloadViewController.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/8/24.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import UIKit
protocol DownloadViewCoordinator: AnyObject {}

class DownloadViewController: UIViewController {
    // MARK: - Props.

    weak var coordinator: DownloadViewCoordinator?
    var viewModel: DownloadViewModel?

    // MARK: - Public

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

// MARK: - Storyboarded

extension DownloadViewController: Storyboarded {
    static var storyboardName: String { return "Download" }
}
