//
//  TabBarWireframe.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/9/29.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import UIKit

class TabBarWireframe: TabBarWireframeProtocol {
    private(set) weak var presenter: TabBarWireframeOutputProtocol?
    private weak var viewController: UIViewController?

    static func create() -> UIViewController {
        let view: TabBarViewController = .init()
        let interactor: TabBarInteractor = .init()
        let wireframe: TabBarWireframe = .init(viewController: view)
        let presenter: TabBarPresenter = .init(view: view, interactor: interactor, wireframe: wireframe)
        view.presenter = presenter
        interactor.presenter = presenter
        wireframe.presenter = presenter
        return view
    }

    private init(viewController: UIViewController?) {
        self.viewController = viewController
    }
}
