//
//  ReadingCoordinator.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/8/24.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import FontAwesome
import Foundation
import UIKit

class ReadingCoordinator: NSObject, ViewCoordinatorProtocol {
    // MARK: - ViewCoordinatorProtocol

    let identifier = UUID()
    private(set) var coordinators: [CoordinatorProtocol] = []
    var viewController: UIViewController { return navigationController }

    func start() {
        navigationController.pushViewController(ReadingViewController(coordinator: self, viewModel: ReadingViewModel()), animated: false)
    }

    // MARK: - Props.

    private let navigationController: UINavigationController

    // MARK: - Public

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
    }
}

// MARK: - ReadingViewCoordinator

extension ReadingCoordinator: ReadingViewCoordinator {}
