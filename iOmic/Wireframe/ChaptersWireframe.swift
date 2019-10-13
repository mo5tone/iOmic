//
//  ChaptersWireframe.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/10/3.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import UIKit

class ChaptersWireframe: ChaptersWireframeProtocol {
    private(set) weak var presenter: ChaptersWireframeOutputProtocol?
    private weak var viewController: UIViewController?

    static func create(with book: Book) -> UIViewController {
        let storyboard: UIStoryboard = .init(name: "Books", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ChaptersViewController")
        guard let view = viewController as? ChaptersViewController else { fatalError("Instance of ChaptersViewController expected.") }
        view.hidesBottomBarWhenPushed = true
        let interactor: ChaptersInteractor = .init(source: book.source, databaseManager: DatabaseManager.shared)
        let wireframe: ChaptersWireframe = .init(viewController: view)
        let presenter: ChaptersPresenter = .init(view: view, interactor: interactor, wireframe: wireframe, book: book)
        view.presenter = presenter
        interactor.presenter = presenter
        wireframe.presenter = presenter
        return view
    }

    func showPagesView(where chapter: Chapter) {
        viewController?.show(PagesWireframe.create(with: chapter), sender: viewController)
    }

    private init(viewController: UIViewController?) {
        self.viewController = viewController
    }
}
