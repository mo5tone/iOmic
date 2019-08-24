//
//  ExploreViewController.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/8/24.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import UIKit

protocol ExploreViewCoordinator: AnyObject {}

class ExploreViewController: UIViewController {
    // MARK: - props.

    weak var coordinator: ExploreViewCoordinator?
    var viewModel: ExploreViewModel?

    // MARK: - Public

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

// MARK: - Storyboarded

extension ExploreViewController: Storyboarded {
    static var storyboardName: String { return "Explore" }
}
