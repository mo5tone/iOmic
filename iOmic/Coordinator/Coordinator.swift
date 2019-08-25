//
//  Coordinator.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/8/24.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation
import RxSwift
#if DEBUG
    import FLEX
#endif

protocol CoordinatorProtocol {
    var identifier: UUID { get }
    var coordinators: [CoordinatorProtocol] { get }
    func start()
}

// MARK: - Equatable

extension CoordinatorProtocol where Self: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

protocol WindowCoordinatorProtocol: CoordinatorProtocol {
    var window: UIWindow { get }
}

protocol ViewCoordinatorProtocol: CoordinatorProtocol {
    var viewController: UIViewController { get }
}
