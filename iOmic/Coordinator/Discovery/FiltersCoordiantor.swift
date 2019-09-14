//
//  SourceFiltersCoordinator.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/9/4.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation
import RxSwift
import SwiftEntryKit
import UIKit

protocol FiltersCoordiantorDelegate: CoordinatorDelegate {}

class FiltersCoordiantor: Coordinator, NavigationCoordinatorProtocol {
    let filters: PublishSubject<[FilterProrocol]> = .init()
    private weak var delegate: FiltersCoordiantorDelegate?
    private(set) var viewController: UIViewController = .init()
    private(set) var navigationController: UINavigationController = .init()

    init(window: UIWindow, delegate: FiltersCoordiantorDelegate?, filters: [FilterProrocol]) {
        super.init(window: window)
        self.delegate = delegate
        viewController = FiltersViewController(coordinator: self, viewModel: .init(filters: filters))
        navigationController = .init(rootViewController: viewController)
    }
}

// MARK: - FiltersViewCoordinator

extension FiltersCoordiantor: FiltersViewCoordinator {
    func beingDismissed() {
        delegate?.coordinatorDidEnd(self)
    }

    func dismiss() {
        navigationController.popToRootViewController(animated: true)
        navigationController.dismiss(animated: true, completion: { [weak self] in self?.beingDismissed() })
    }

    func applyFilters(_ filters: [FilterProrocol]) {
        self.filters.on(.next(filters))
    }
}
