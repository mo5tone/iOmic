//
//  UploadCoordinator.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/9/16.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation
import UIKit

protocol UploadCoordinatorDelegate: CoordinatorDelegate {}

class UploadCoordinator: Coordinator, NavigationCoordinatorProtocol {
    private weak var delegate: UploadCoordinatorDelegate?
    private(set) var viewController: UIViewController = .init()
    private(set) var navigationController: UINavigationController = .init()

    init(window: UIWindow, delegate: UploadCoordinatorDelegate?) {
        super.init(window: window)
        self.delegate = delegate
        viewController = UploadViewController(coordinator: self, viewModel: .init(uploader: Uploader.shared))
        navigationController = .init(rootViewController: viewController)
    }
}

extension UploadCoordinator: UploadViewCoordinator {
    func beingDismissed() {
        delegate?.coordinatorDidEnd(self)
    }

    func dismiss() {
        navigationController.popToRootViewController(animated: true)
        navigationController.dismiss(animated: true, completion: { [weak self] in self?.beingDismissed() })
    }
}
