//
//  DiscoveryWireframe.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/9/29.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import UIKit

class DiscoveryWireframe: DiscoveryWireframeProtocol {
    static func create() -> UIViewController {
        let storyboard: UIStoryboard = .init(name: "Discovery", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "DiscoveryViewController")
        guard let view = viewController as? DiscoveryViewController else { fatalError("Instance of DiscoveryViewController expected.") }
        let interactor: DiscoveryInteractor = .init()
        let wireframe: DiscoveryWireframe = .init()
        let presenter: DiscoveryPresenter = .init(view: view, interactor: interactor, wireframe: wireframe)
        view.presenter = presenter
        interactor.presenter = presenter
        let navigationController: UINavigationController = .init(rootViewController: view)
        navigationController.tabBarItem = .init(title: "Discovery", image: #imageLiteral(resourceName: "ic_tabbar_discovery"), tag: 1)
        return navigationController
    }
}
