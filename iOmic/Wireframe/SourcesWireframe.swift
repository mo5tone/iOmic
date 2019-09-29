//
//  SourcesWireframe.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/9/29.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import UIKit

class SourcesWireframe: SourcesWireframeProtocol {
    private let viewController: SourcesViewController

    static func create() -> UIViewController {
        let storyboard: UIStoryboard = .init(name: "Discovery", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "SourcesViewController")
        guard let view = viewController as? SourcesViewController else { fatalError("Instance of SourcesViewController expected.") }
        let interactor: SourcesInteractor = .init()
        let wireframe: SourcesWireframe = .init(viewController: view)
        let presenter: SourcesPresenter = .init(view: view, interactor: interactor, wireframe: wireframe)
        view.presenter = presenter
        interactor.presenter = presenter
        return view
    }

    private init(viewController: SourcesViewController) {
        self.viewController = viewController
    }
}
