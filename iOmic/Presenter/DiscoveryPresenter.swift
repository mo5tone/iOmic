//
//  DiscoveryPresenter.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/9/29.
//  Copyright © 2019 门捷夫. All rights reserved.
//

class DiscoveryPresenter: DiscoveryPresenterProtocol {
    // MARK: - Instance properties

    private(set) weak var view: DiscoveryViewProtocol?
    private(set) var interactor: DiscoveryInteractorProtocol
    private(set) var wireframe: DiscoveryWireframeProtocol
    private var source: Source = .dongmanzhijia
    private var page: Int = 0

    // MARK: - Init

    init(view: DiscoveryViewProtocol?, interactor: DiscoveryInteractorProtocol, wireframe: DiscoveryWireframeProtocol) {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
    }
}

// MARK: - DiscoveryWireframeOutputProtocol

extension DiscoveryPresenter: DiscoveryWireframeOutputProtocol {
    func didSelectSource(_ source: Source) {
        guard self.source != source else { return }
        self.source = source
        loadContent()
    }
}

// MARK: - DiscoveryViewOutputProtocol

extension DiscoveryPresenter: DiscoveryViewOutputProtocol {
    func viewDidLoad() {
        loadContent()
    }

    func presentSourcesViewController() {
        wireframe.presentSourcesModule(current: source)
    }

    func loadContent(where query: String = "", sortedBy fetchingSort: Source.FetchingSort = .popularity, refresh: Bool = true) {
        page = refresh ? 0 : page + 1
        interactor.fetchBooks(in: source, where: page, query: query, sortedBy: fetchingSort)
    }
}

// MARK: - DiscoveryInteractorOutputProtocol

extension DiscoveryPresenter: DiscoveryInteractorOutputProtocol {
    func didFetchBooks(_ books: [Book]) {
        if page > 0 {
            view?.add(more: books)
        } else {
            view?.update(source: source, books: books)
        }
    }
}
