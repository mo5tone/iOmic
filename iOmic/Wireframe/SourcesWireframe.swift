//
//  SourcesWireframe.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/9/29.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import UIKit

class SourcesWireframe: SourcesWireframeProtocol {
    private(set) weak var presenter: SourcesWireframeOutputProtocol?
    private(set) weak var delegate: SourcesModuleDelegate?
    private weak var viewController: UIViewController?

    static func create(with source: Source, delegate: SourcesModuleDelegate?) -> UIViewController {
        let storyboard: UIStoryboard = .init(name: "Discovery", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "SourcesViewController")
        guard let view = viewController as? SourcesViewController else { fatalError("Instance of SourcesViewController expected.") }
        let interactor: SourcesInteractor = .init(keyValues: KeyValues.shared)
        let wireframe: SourcesWireframe = .init(viewController: view, delegate: delegate)
        let presenter: SourcesPresenter = .init(view: view, interactor: interactor, wireframe: wireframe, source: source)
        view.presenter = presenter
        interactor.presenter = presenter
        wireframe.presenter = presenter
        return UINavigationController(rootViewController: view)
    }

    func dismiss(with source: Source) {
        viewController?.navigationController?.dismiss(animated: true) { [weak self] in self?.delegate?.didSelectSource(source) }
    }

    private init(viewController: UIViewController?, delegate: SourcesModuleDelegate?) {
        self.viewController = viewController
        self.delegate = delegate
    }
}
