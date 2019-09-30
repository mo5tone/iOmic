//
//  BooksWireframe.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/9/29.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import UIKit

class BooksWireframe: BooksWireframeProtocol {
    private(set) weak var presenter: BooksWireframeOutputProtocol?
    private(set) weak var view: BooksViewController?

    static func create() -> UIViewController {
        let storyboard: UIStoryboard = .init(name: "Books", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "BooksViewController")
        guard let view = viewController as? BooksViewController else { fatalError("Instance of BooksViewController expected.") }
        let interactor: BooksInteractor = .init()
        let wireframe: BooksWireframe = .init(view: view)
        let presenter: BooksPresenter = .init(view: view, interactor: interactor, wireframe: wireframe)
        view.presenter = presenter
        interactor.presenter = presenter
        wireframe.presenter = presenter
        let navigationController: UINavigationController = .init(rootViewController: view)
        navigationController.tabBarItem = .init(title: "Books", image: #imageLiteral(resourceName: "ic_tabbar_books"), tag: 0)
        return navigationController
    }

    private init(view: BooksViewController?) {
        self.view = view
    }
}
