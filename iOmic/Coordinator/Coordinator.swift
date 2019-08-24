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

class Coordinator: NSObject {
    // MARK: - Props.

    let identifier = UUID()
    private(set) var children = [Coordinator]()

    // MARK: - Public

    func showFLEXExplorer() {
        #if DEBUG
            FLEXManager.shared()?.showExplorer()
        #endif
    }

    func hideFLEXExplorer() {
        #if DEBUG
            FLEXManager.shared()?.hideExplorer()
        #endif
    }

    func appendChildCoordinator(_ child: Coordinator) {
        removeChildCoordinator(child)
        children.append(child)
    }

    func removeChildCoordinator(_ child: Coordinator) {
        children.removeAll(where: { $0.identifier == child.identifier })
    }

    func start() {
        fatalError("`start` method should be implemented.")
    }
}
