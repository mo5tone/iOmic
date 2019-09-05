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

protocol SourceFiltersCoordiantorDelegate: CoordinatorDelegate {}

class SourceFiltersCoordiantor: ViewCoordinator {
    private let filters: PublishSubject<[FilterProrocol]> = .init()
    private weak var delegate: SourceFiltersCoordiantorDelegate?

    init(window: UIWindow, delegate: SourceFiltersCoordiantorDelegate?, filters: [FilterProrocol]) {
        super.init(window: window)
        self.delegate = delegate
        viewController = SourceFiltersViewController(coordinator: self, viewModel: .init(filters: filters))
    }

    func start() -> Observable<[FilterProrocol]> {
        var attributes: EKAttributes = .bottomNote
        attributes.name = String(describing: SourceFiltersViewController.self)
        attributes.displayDuration = .infinity
        attributes.positionConstraints.safeArea = .empty(fillSafeArea: false)
        attributes.positionConstraints.size = .init(width: .offset(value: 8), height: .ratio(value: 0.7))
        let action: EKAttributes.UserInteraction.Action = { [weak self] in self?.dismiss() }
        attributes.screenInteraction = .init(defaultAction: .absorbTouches, customTapActions: [action])
        attributes.entryBackground = .color(color: .init(.groupTableViewBackground))
        attributes.screenBackground = .visualEffect(style: .standard)
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.3, radius: 10, offset: .zero))
        attributes.roundCorners = .all(radius: 16)
        SwiftEntryKit.display(entry: viewController, using: attributes)
        return filters
    }
}

// MARK: - SourceFiltersViewCoordinator

extension SourceFiltersCoordiantor: SourceFiltersViewCoordinator {
    func dismiss() {
        SwiftEntryKit.dismiss(.specific(entryName: String(describing: SourceFiltersViewController.self))) { [weak self] in
            guard let self = self else { return }
            self.delegate?.coordinatorDidEnd(self)
        }
    }

    func applyFilters(_ filters: [FilterProrocol]) {
        self.filters.on(.next(filters))
    }
}
