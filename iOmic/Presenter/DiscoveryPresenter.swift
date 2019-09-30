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
    private var query: String = ""
    private var fetchingSort: Source.FetchingSort = .popularity

    // MARK: - Init

    init(view: DiscoveryViewProtocol?, interactor: DiscoveryInteractorProtocol, wireframe: DiscoveryWireframeProtocol) {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
    }

    // MARK: - Private instance methods

    private func load() {
        interactor.fetchBooks(in: source, where: page, query: query, sortedBy: fetchingSort)
    }
}

// MARK: - DiscoveryWireframeOutputProtocol

extension DiscoveryPresenter: DiscoveryWireframeOutputProtocol {
    func update(source: Source) {
        guard self.source != source else { return }
        self.source = source
        refresh()
    }
}

// MARK: - DiscoveryViewOutputProtocol

extension DiscoveryPresenter: DiscoveryViewOutputProtocol {
    func viewDidLoad() {
        load()
    }

    func didTapSourcesBarButtonItem() {
        wireframe.presentSourcesModule(current: source)
    }

    func refresh() {
        page = 0
        query = ""
        fetchingSort = .popularity
        load()
    }

    func loadMore() {
        page += 1
        load()
    }
}

// MARK: - DiscoveryInteractorOutputProtocol

extension DiscoveryPresenter: DiscoveryInteractorOutputProtocol {
    func update(books: [Book]) {
        if page > 0 {
            view?.add(more: books)
        } else {
            view?.update(source: source, books: books)
        }
    }
}
