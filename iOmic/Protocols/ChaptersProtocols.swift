//
//  ChaptersProtocols.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/10/3.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import UIKit

protocol ChaptersWireframeProtocol: AnyObject {
    var presenter: ChaptersWireframeOutputProtocol? { get }
    static func create(with book: Book) -> UIViewController
    func showPagesView(where chapter: Chapter)
}

protocol ChaptersViewProtocol: AnyObject {
    var presenter: ChaptersViewOutputProtocol! { get set }
    func reload(book: Book)
    func reload(chapters: [Chapter])
}

protocol ChaptersInteractorProtocol: AnyObject {
    var presenter: ChaptersInteractorOutputProtocol? { get }
    func fetch(where book: Book)
    func set(book: Book, isFavorite: Bool)
}

protocol ChaptersWireframeOutputProtocol: AnyObject {}

protocol ChaptersViewOutputProtocol: AnyObject {
    func viewDidLoad()
    func fetch()
    func showPagesView(where chapter: Chapter)
    func setFavorite()
}

protocol ChaptersInteractorOutputProtocol: AnyObject {
    func didFetch(book: Book, chapters: [Chapter])
    func didSetFavorite(_ isFavorite: Bool)
}

protocol ChaptersPresenterProtocol: AnyObject {
    var view: ChaptersViewProtocol? { get }
    var interactor: ChaptersInteractorProtocol { get }
    var wireframe: ChaptersWireframeProtocol { get }
}
