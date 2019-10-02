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
    func presentSourcesModule(current source: Source)
}

protocol DiscoveryViewProtocol: AnyObject {
    var presenter: DiscoveryViewOutputProtocol! { get set }
    func update(source: Source, books: [Book])
    func add(more books: [Book])
}

protocol DiscoveryInteractorProtocol: AnyObject {
    var presenter: DiscoveryInteractorOutputProtocol? { get }
    func fetchBooks(in source: SourceProtocol, where page: Int, query: String, sortedBy fetchingSort: Source.FetchingSort)
}

protocol DiscoveryWireframeOutputProtocol: AnyObject {
    func didSelectSource(_ source: Source)
}

protocol DiscoveryViewOutputProtocol: AnyObject {
    func viewDidLoad()
    func presentSourcesView()
    func loadContent(where query: String, sortedBy fetchingSort: Source.FetchingSort, refresh: Bool)
}

protocol DiscoveryInteractorOutputProtocol: AnyObject {
    func didFetchBooks(_ books: [Book])
}

protocol DiscoveryPresenterProtocol: AnyObject {
    var view: DiscoveryViewProtocol? { get }
    var interactor: DiscoveryInteractorProtocol { get }
    var wireframe: DiscoveryWireframeProtocol { get }
}
