//
//  TabBarWireframe.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/9/29.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import UIKit

class TabBarWireframe: TabBarWireframeProtocol {
    static func create() -> UIViewController {
        let view: TabBarViewController = .init()
        let interactor: TabBarInteractor = .init()
        let wireframe: TabBarWireframe = .init()
        let presenter: TabBarPresenter = .init(view: view, interactor: interactor, wireframe: wireframe)
        view.presenter = presenter
        interactor.presenter = presenter
        return view
    }
}
