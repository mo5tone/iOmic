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

class ReadingCoordinator: Coordinator {
    // MARK: - Props.

    // MARK: - Public

    override init(window: UIWindow) {
        super.init(window: window)
        viewController = UINavigationController()
    }

    func start() {
        guard let navigationController = viewController as? UINavigationController else { return }
        navigationController.pushViewController(ReadingViewController(coordinator: self, viewModel: ReadingViewModel()), animated: false)
    }
}

// MARK: - ReadingViewCoordinator

extension ReadingCoordinator: ReadingViewCoordinator {}
