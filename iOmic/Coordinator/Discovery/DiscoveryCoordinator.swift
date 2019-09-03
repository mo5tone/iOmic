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

    override init(window: UIWindow) {
        super.init(window: window)
        let rootViewController = DiscoveryViewController(coordinator: self, viewModel: .init(DongManZhiJia.shared))
        self.rootViewController = rootViewController
        navigationController = .init(rootViewController: rootViewController)
        navigationController.navigationBar.prefersLargeTitles = true
    }
}

extension DiscoveryCoordinator: DiscoveryViewCoordinator {
    func popupSourcesSwitcher(current _: SourceProtocol, observer: AnyObserver<SourceProtocol>) {
        let alertController: UIAlertController = .init(title: nil, message: nil, preferredStyle: .actionSheet)
        Source.all.forEach { source in
            alertController.addAction(.init(title: source.name, style: .default, handler: { _ in observer.on(.next(source)) }))
        }
        alertController.addAction(.init(title: "Cancel", style: .cancel, handler: nil))
        // FIXME: - https://stackoverflow.com/questions/55653187/swift-default-alertviewcontroller-breaking-constraints
        alertController.view.addSubview(UIView())
        rootViewController?.present(alertController, animated: false, completion: {})
    }

    func popupFiltersPicker(current _: [FilterProrocol]) {
        // TODO: -
        let controller = SourceFiltersViewController()
        var attributes: EKAttributes = .bottomFloat
        attributes.displayDuration = .infinity
        attributes.positionConstraints.safeArea = .empty(fillSafeArea: false)
        attributes.positionConstraints.size = .init(width: .offset(value: 8), height: .ratio(value: 0.75))
        attributes.entryInteraction = .absorbTouches
        attributes.screenInteraction = .dismiss
        attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
        attributes.entryBackground = .color(color: .init(.white))
        attributes.screenBackground = .clear
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.3, radius: 10, offset: .zero))
        attributes.roundCorners = .all(radius: 16)
        SwiftEntryKit.display(entry: controller, using: attributes)
    }
}
