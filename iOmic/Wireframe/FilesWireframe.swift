//
//  FilesWireframe.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/9/29.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import UIKit

class FilesWireframe: FilesWireframeProtocol {
    private(set) weak var presenter: FilesWireframeOutputProtocol?
    private(set) weak var view: FilesViewController?

    static func create() -> UIViewController {
        let storyboard: UIStoryboard = .init(name: "Files", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "FilesViewController")
        guard let view = viewController as? FilesViewController else { fatalError("Instance of FilesViewController expected.") }
        let interactor: FilesInteractor = .init()
        let wireframe: FilesWireframe = .init(view: view)
        let presenter: FilesPresenter = .init(view: view, interactor: interactor, wireframe: wireframe)
        view.presenter = presenter
        interactor.presenter = presenter
        wireframe.presenter = presenter
        let navigationController: UINavigationController = .init(rootViewController: view)
        navigationController.tabBarItem = .init(title: "Files", image: #imageLiteral(resourceName: "ic_tabbar_upload"), tag: 2)
        return navigationController
    }

    private init(view: FilesViewController?) {
        self.view = view
    }
}
