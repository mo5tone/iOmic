//
//  Coordinator.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/8/24.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

class Coordinator: NSObject {
    // MARK: - Props.

    let window: UIWindow

    var viewController: UIViewController?

    var coordinators: [Coordinator] = []

    // MARK: - Public

    init(window: UIWindow) {
        self.window = window
        super.init()
    }

    func makeKeyAndVisible() {
        guard let viewController = viewController else {
            return
        }
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }
}
