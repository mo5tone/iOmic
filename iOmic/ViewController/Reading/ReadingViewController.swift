//
//  ReadingViewController.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/8/24.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import UIKit

protocol ReadingViewCoordinator: AnyObject {}

class ReadingViewController: UIViewController {
    // MARK: - Props.

    weak var coordinator: ReadingViewCoordinator?
    var viewModel: ReadingViewModel?

    // MARK: - Public

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        assert(coordinator != nil, "coordinator can not be nil!")
        assert(viewModel != nil, "viewModel can not be nil!")
    }
}

extension ReadingViewController: Storyboarded {
    static var storyboardName: String {
        return "Reading"
    }
}
