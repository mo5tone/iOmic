//
//  UpDownLoadCoordinator.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/8/24.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation
import UIKit

protocol UpDownLoadCoordinatorDelegate: CoordinatorDelegate {}

class UpDownLoadCoordinator: Coordinator, NavigationCoordinatorProtocol {
    // MARK: - Props.

    private weak var delegate: UpDownLoadCoordinatorDelegate?
    private(set) var viewController: UIViewController = .init()
    private(set) var navigationController: UINavigationController = .init()

    // MARK: - Public

    init(window: UIWindow, delegate: UpDownLoadCoordinatorDelegate?) {
        super.init(window: window)
        self.delegate = delegate
        viewController = UpDownLoadViewController(coordinator: self, viewModel: .init())
        navigationController = .init(rootViewController: viewController)
    }
}

// MARK: - UpDownLoadViewCoordinator

extension UpDownLoadCoordinator: UpDownLoadViewCoordinator {
    func presentUpload() {
        let coordinator: UploadCoordinator = .init(window: window, delegate: self)
        append(coordinator: coordinator)
        viewController.present(coordinator.navigationController, animated: true, completion: nil)
    }
}

// MARK: - UploadCoordinatorDelegate

extension UpDownLoadCoordinator: UploadCoordinatorDelegate {}
