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

class FiltersCoordiantor: ViewCoordinator {
    private let filters: PublishSubject<[FilterProrocol]> = .init()
    private weak var delegate: FiltersCoordiantorDelegate?

    init(window: UIWindow, delegate: FiltersCoordiantorDelegate?, filters: [FilterProrocol]) {
        super.init(window: window)
        self.delegate = delegate
        viewController = FiltersViewController(coordinator: self, viewModel: .init(filters: filters))
    }

    func start() -> Observable<[FilterProrocol]> {
        var attributes: EKAttributes = .bottomNote
        attributes.name = String(describing: FiltersViewController.self)
        attributes.displayDuration = .infinity
        attributes.positionConstraints.safeArea = .empty(fillSafeArea: false)
        attributes.positionConstraints.size = .init(width: .offset(value: 8), height: .ratio(value: 0.7))
        let action: EKAttributes.UserInteraction.Action = { [weak self] in self?.dismiss() }
        attributes.screenInteraction = .init(defaultAction: .absorbTouches, customTapActions: [action])
        attributes.entryBackground = .color(color: .init(UIColor.flat.background))
        attributes.screenBackground = .visualEffect(style: .standard)
        attributes.shadow = .active(with: .init(color: .init(UIColor.flat.shadow), opacity: 0.3, radius: 10, offset: .zero))
        attributes.roundCorners = .all(radius: 16)
        SwiftEntryKit.display(entry: viewController, using: attributes)
        return filters
    }
}

// MARK: - FiltersViewCoordinator

extension FiltersCoordiantor: FiltersViewCoordinator {
    func dismiss() {
        SwiftEntryKit.dismiss(.specific(entryName: String(describing: FiltersViewController.self))) { [weak self] in
            guard let self = self else { return }
            self.delegate?.coordinatorDidEnd(self)
        }
    }

    func applyFilters(_ filters: [FilterProrocol]) {
        self.filters.on(.next(filters))
    }
}
