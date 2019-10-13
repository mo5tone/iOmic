//
//  PagesWireframe.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/10/9.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import UIKit

class PagesWireframe: PagesWireframeProtocol {
    private(set) weak var presenter: PagesWireframeOutputProtocol?
    private weak var viewController: UIViewController?

    static func create(with chapter: Chapter) -> UIViewController {
        let storyboard: UIStoryboard = .init(name: "Books", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "PagesViewController")
        guard let view = viewController as? PagesViewController else { fatalError("Instance of PagesViewController expected.") }
        let interactor: PagesInteractor = .init()
        let wireframe: PagesWireframe = .init(viewController: view)
        let presenter: PagesPresenter = .init(view: view, interactor: interactor, wireframe: wireframe)
        presenter.chapter = chapter
        view.presenter = presenter
        interactor.presenter = presenter
        wireframe.presenter = presenter
        return view
    }

    private init(viewController: UIViewController?) {
        self.viewController = viewController
    }
}
