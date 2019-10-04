//
//  DiscoveryProtocols.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/9/29.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import UIKit

protocol DiscoveryWireframeProtocol: AnyObject {
    var presenter: DiscoveryWireframeOutputProtocol? { get }
    static func create() -> UIViewController
    func showDetailSourcesView(current source: Source)
    func showChaptersView(book: Book)
}

protocol DiscoveryViewProtocol: AnyObject {
    var presenter: DiscoveryViewOutputProtocol! { get set }
    func reload(source: Source, more: Bool, books: [Book])
}

protocol DiscoveryInteractorProtocol: AnyObject {
    var presenter: DiscoveryInteractorOutputProtocol? { get }
    func fetch(in source: SourceProtocol, page: Int, query: String, sortedBy fetchingSort: Source.FetchingSort)
}

protocol DiscoveryWireframeOutputProtocol: AnyObject {
    func didSelectSource(_ source: Source)
}

protocol DiscoveryViewOutputProtocol: AnyObject {
    func viewDidLoad()
    func showDetailSourcesView()
    func fetch(where query: String, sortedBy fetchingSort: Source.FetchingSort, refresh: Bool)
    func showChaptersView(book: Book)
}

protocol DiscoveryInteractorOutputProtocol: AnyObject {
    func didFetch(books: [Book])
}

protocol DiscoveryPresenterProtocol: AnyObject {
    var view: DiscoveryViewProtocol? { get }
    var interactor: DiscoveryInteractorProtocol { get }
    var wireframe: DiscoveryWireframeProtocol { get }
}
