//
//  SourceFiltersCoordinator.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/9/4.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation
import SwiftEntryKit
import UIKit

class SourceFiltersCoordiantor: ViewCoordinator {
    private var filters: [FilterProrocol]
    init(window: UIWindow, filters: [FilterProrocol]) {
        self.filters = filters
        super.init(window: window)
        viewController = SourceFiltersViewController(coordinator: self, viewModel: .init(filters: filters))
    }

    func start() {
        var attributes: EKAttributes = .bottomNote
        attributes.name = String(describing: SourceFiltersViewController.self)
        attributes.displayDuration = .infinity
        attributes.positionConstraints.safeArea = .empty(fillSafeArea: false)
        attributes.positionConstraints.size = .init(width: .offset(value: 8), height: .ratio(value: 0.7))
        attributes.screenInteraction = .dismiss
        attributes.entryBackground = .color(color: .init(.groupTableViewBackground))
        attributes.screenBackground = .visualEffect(style: .standard)
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.3, radius: 10, offset: .zero))
        attributes.roundCorners = .all(radius: 16)
        SwiftEntryKit.display(entry: viewController, using: attributes)
    }
}

// MARK: - SourceFiltersViewCoordinator

extension SourceFiltersCoordiantor: SourceFiltersViewCoordinator {}
