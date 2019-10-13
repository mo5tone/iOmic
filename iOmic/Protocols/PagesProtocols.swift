//
//  PagesProtocols.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/10/9.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import UIKit

protocol PagesWireframeProtocol: AnyObject {
    var presenter: PagesWireframeOutputProtocol? { get }
    static func create(with chapter: Chapter) -> UIViewController
}

protocol PagesViewProtocol: AnyObject {
    var presenter: PagesViewOutputProtocol! { get set }
    func reload(chapter: Chapter, pages: [Page])
}

protocol PagesInteractorProtocol: AnyObject {
    var presenter: PagesInteractorOutputProtocol? { get }
    func fetch(where chapter: Chapter)
}

protocol PagesWireframeOutputProtocol: AnyObject {}

protocol PagesViewOutputProtocol: AnyObject {
    func viewDidLoad()
    func fetch()
}

protocol PagesInteractorOutputProtocol: AnyObject {
    func didFetch(chapter: Chapter, pages: [Page])
}

protocol PagesPresenterProtocol: AnyObject {
    var view: PagesViewProtocol? { get }
    var interactor: PagesInteractorProtocol { get }
    var wireframe: PagesWireframeProtocol { get }
}
