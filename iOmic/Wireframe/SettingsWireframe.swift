//
//  SettingsWireframe.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/9/29.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import UIKit

class SettingsWireframe: SettingsWireframeProtocol {
    static func create() -> UIViewController {
        let storyboard: UIStoryboard = .init(name: "Settings", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "SettingsViewController")
        guard let view = viewController as? SettingsViewController else { fatalError("Instance of SettingsViewController expected.") }
        let interactor: SettingsInteractor = .init()
        let wireframe: SettingsWireframe = .init()
        let presenter: SettingsPresenter = .init(view: view, interactor: interactor, wireframe: wireframe)
        view.presenter = presenter
        interactor.presenter = presenter
        let navigationController: UINavigationController = .init(rootViewController: view)
        navigationController.tabBarItem = .init(title: "Files", image: #imageLiteral(resourceName: "ic_tabbar_setting"), tag: 3)
        return navigationController
    }
}
