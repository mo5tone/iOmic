//
//  DiscoveryCoordinator.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/8/24.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation
import SwiftEntryKit
import UIKit

class DiscoveryCoordinator: Coordinator {
    // MARK: - Props.

    // MARK: - Public

    override init(window: UIWindow) {
        super.init(window: window)
        viewController = UINavigationController()
    }

    func start() {
        guard let navigationController = viewController as? UINavigationController else { return }
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.pushViewController(DiscoveryViewController(coordinator: self, viewModel: .init()), animated: false)
    }
}

extension DiscoveryCoordinator: DiscoveryViewCoordinator {
    func popupSourcesSwitcher(current _: SourceProtocol) {
        // TODO: -
        let controller = SourceFiltersViewController()
        var attributes: EKAttributes = .topFloat
        attributes.displayDuration = .infinity
        attributes.positionConstraints.safeArea = .empty(fillSafeArea: false)
        attributes.positionConstraints.size = .init(width: .offset(value: 8), height: .ratio(value: 0.25))
        attributes.screenInteraction = .dismiss
        attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
        attributes.entryBackground = .color(color: .init(.white))
        attributes.screenBackground = .visualEffect(style: .extra)
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.3, radius: 10, offset: .zero))
        attributes.roundCorners = .all(radius: 16)
        SwiftEntryKit.display(entry: controller, using: attributes)
    }

    func popupFiltersPicker(current _: [FilterProrocol]) {
        // TODO: -
        let controller = SourceFiltersViewController()
        var attributes: EKAttributes = .bottomFloat
        attributes.displayDuration = .infinity
        attributes.positionConstraints.safeArea = .empty(fillSafeArea: false)
        attributes.positionConstraints.size = .init(width: .offset(value: 8), height: .ratio(value: 0.75))
        attributes.screenInteraction = .dismiss
        attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
        attributes.entryBackground = .color(color: .init(.white))
        attributes.screenBackground = .visualEffect(style: .extra)
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.3, radius: 10, offset: .zero))
        attributes.roundCorners = .all(radius: 16)
        SwiftEntryKit.display(entry: controller, using: attributes)
    }
}
