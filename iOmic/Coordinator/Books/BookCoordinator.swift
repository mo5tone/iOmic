//
//  BookCoordinator.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/9/5.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation
import UIKit

protocol BookCoordinatorDelegate: CoordinatorDelegate {}

class BookCoordinator: ViewCoordinator {
    // MARK: - instace props.

    private weak var delegate: BookCoordinatorDelegate?
    private weak var navigationController: UINavigationController?

    // MARK: - public methods

    init(window: UIWindow, delegate: BookCoordinatorDelegate?, navigationController _: UINavigationController?, book: Book) {
        super.init(window: window)
        self.delegate = delegate
        viewController = BookViewController(coordinator: self, viewModel: .init(book: book))
    }
}

// MARK: - BookViewCoordinator

extension BookCoordinator: BookViewCoordinator {}
