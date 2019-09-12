//
//  BooksCoordinator.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/8/24.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation
import UIKit

protocol BooksCoordinatorDelegate: CoordinatorDelegate {}

class BooksCoordinator: Coordinator, NavigationCoordinatorProtocol {
    // MARK: - Props.

    private weak var delegate: BooksCoordinatorDelegate?
    private(set) var viewController: UIViewController = .init()
    private(set) var navigationController: UINavigationController = .init()

    // MARK: - Public

    init(window: UIWindow, delegate: BooksCoordinatorDelegate?) {
        super.init(window: window)
        self.delegate = delegate
        viewController = BooksViewController(coordinator: self, viewModel: .init(persistence: Persistence.shared))
        navigationController = .init(rootViewController: viewController)
    }
}

// MARK: - BooksViewCoordinator

extension BooksCoordinator: BooksViewCoordinator {
    func showChapters(in book: Book) {
        let coordinator: ChaptersCoordinator = .init(window: window, delegate: self, book: book)
        append(coordinator: coordinator)
        navigationController.pushViewController(coordinator.viewController, animated: true)
    }
}

// MARK: - ChaptersCoordinatorDelegate

extension BooksCoordinator: ChaptersCoordinatorDelegate {}
