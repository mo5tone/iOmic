//
//  BooksWireframe.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/9/29.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import UIKit

class BooksWireframe: BooksWireframeProtocol {
    private let viewController: BooksViewController

    static func create() -> UIViewController {
        let storyboard: UIStoryboard = .init(name: "Books", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "BooksViewController")
        guard let view = viewController as? BooksViewController else { fatalError("Instance of BooksViewController expected.") }
        let interactor: BooksInteractor = .init()
        let wireframe: BooksWireframe = .init(viewController: view)
        let presenter: BooksPresenter = .init(view: view, interactor: interactor, wireframe: wireframe)
        view.presenter = presenter
        interactor.presenter = presenter
        let navigationController: UINavigationController = .init(rootViewController: view)
        navigationController.tabBarItem = .init(title: "Books", image: #imageLiteral(resourceName: "ic_tabbar_books"), tag: 0)
        return navigationController
    }

    private init(viewController: BooksViewController) {
        self.viewController = viewController
    }
}
