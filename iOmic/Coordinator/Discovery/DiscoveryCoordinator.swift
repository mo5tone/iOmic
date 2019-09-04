//
//  DiscoveryCoordinator.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/8/24.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation
import RxSwift
import SwiftEntryKit
import UIKit

class DiscoveryCoordinator: NavigationCoordinator {
    // MARK: - Props.

    private let bag: DisposeBag = .init()

    // MARK: - Public

    override init(window: UIWindow, flowDelegate: CoordinatorFlowDelegate? = nil) {
        super.init(window: window, flowDelegate: flowDelegate)
        viewController = DiscoveryViewController(coordinator: self, viewModel: .init())
        navigationController = .init(rootViewController: viewController)
        navigationController.navigationBar.prefersLargeTitles = true
    }
}

// MARK: - DiscoveryViewCoordinator

extension DiscoveryCoordinator: DiscoveryViewCoordinator {
    func popupSourcesSwitcher(current _: SourceProtocol) -> Observable<SourceProtocol> {
        let alertController: UIAlertController = .init(title: nil, message: nil, preferredStyle: .actionSheet)
        let subject: PublishSubject<SourceProtocol> = .init()
        Source.all.map { source in .init(title: source.name, style: .default, handler: { _ in subject.on(.next(source)) }) }.forEach { alertController.addAction($0) }
        alertController.addAction(.init(title: "Cancel", style: .cancel, handler: nil))
        // FIXME: - https://stackoverflow.com/questions/55653187/swift-default-alertviewcontroller-breaking-constraints
        alertController.view.addSubview(UIView())
        viewController.present(alertController, animated: false, completion: {})
        return subject
    }

    func popupFiltersPicker(current: [FilterProrocol]) {
        let coordinator: SourceFiltersCoordiantor = .init(window: window, flowDelegate: self, filters: current)
        append(coordinator: coordinator)
        coordinator.start()
    }
}
